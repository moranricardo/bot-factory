import fs from 'fs/promises';
import path from 'path';
import os from 'os';

const BOT_FACTORY_DIR = process.env.BOT_FACTORY_PATH || path.join(os.homedir(), 'bot-factory');
const STATE_FILE = path.join(BOT_FACTORY_DIR, 'state.json');

export class GerritClient {
  constructor(baseUrl = process.env.GERRIT_URL || 'https://android-review.googlesource.com') {
    this.baseUrl = baseUrl;
  }

  // Sanitización de seguridad (Protocolo Maat)
  sanitizeResponse(text) {
    // Elimina el prefijo anti-XSSI de Gerrit: )]}'
    return text.replace(/^\s*\)\]\}'\s*/, '');
  }

  // Actualiza el estado en el archivo maestro de telemetría (state.json)
  async updateTelemetry(status, details = {}) {
    try {
      const rawData = await fs.readFile(STATE_FILE, 'utf-8');
      const state = JSON.parse(rawData);

      if (!state.nodes) state.nodes = {};
      state.nodes["Gerrit-Client"] = {
        status: status,
        last_update: new Date().toISOString(),
        ...details
      };

      const tempFile = `${STATE_FILE}.tmp`;
      await fs.writeFile(tempFile, JSON.stringify(state, null, 2), 'utf-8');
      await fs.rename(tempFile, STATE_FILE);
    } catch (err) {
      console.error(`[Gerrit-Client] Error actualizando telemetría: ${err.message}`);
    }
  }

  // Interrogación de cambios en Gerrit
  async fetchChanges(query = 'status:open limit:5') {
    await this.updateTelemetry('Ejecutando', { current_action: 'fetchChanges' });

    try {
      const url = `${this.baseUrl}/changes/?q=${encodeURIComponent(query)}`;
      console.log(`[Gerrit-Client] Consultando: ${url}`);

      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const rawText = await response.text();
      const cleanJsonText = this.sanitizeResponse(rawText);
      const changes = JSON.parse(cleanJsonText);

      await this.updateTelemetry('Activo', {
        last_query: query,
        results_count: changes.length,
        last_success: new Date().toISOString()
      });

      return changes;
    } catch (error) {
      console.error(`[Gerrit-Client] Error en consulta: ${error.message}`);
      await this.updateTelemetry('Error', { last_error: error.message });
      throw error;
    }
  }
}

// Ejecución directa de prueba
if (import.meta.url === `file://${process.argv[1]}`) {
  const client = new GerritClient();
  
  console.log("=== Ejecutando Prueba de Gerrit-Client ===");
  try {
    const changes = await client.fetchChanges('status:open limit:3');
    console.log(`\n✅ Cambios recuperados exitosamente (${changes.length}):`);
    changes.forEach((c, index) => {
      console.log(`  ${index + 1}. [${c.change_id?.substring(0, 8)}] ${c.subject} (${c.project})`);
    });
  } catch (err) {
    console.error("❌ Fallo en la prueba de Gerrit-Client:", err.message);
  }
}
