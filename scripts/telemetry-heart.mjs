import fs from 'fs/promises';
import path from 'path';
import os from 'os';

const BOT_FACTORY_DIR = process.env.BOT_FACTORY_PATH || path.join(os.homedir(), 'bot-factory');
const STATE_FILE = path.join(BOT_FACTORY_DIR, 'state.json');
const LOGS_DIR = path.join(BOT_FACTORY_DIR, 'logs');
const LOG_FILE = path.join(LOGS_DIR, 'telemetry.log');

export class TelemetryHeart {
  constructor(options = {}) {
    this.intervalMs = options.intervalMs || 30000;
    this.timer = null;
  }

  async init() {
    await fs.mkdir(BOT_FACTORY_DIR, { recursive: true });
    await fs.mkdir(LOGS_DIR, { recursive: true });
    await this.ensureStateFile();
  }

  async ensureStateFile() {
    try {
      await fs.access(STATE_FILE);
    } catch {
      const initialState = {
        system: {
          name: "Ra Pulse",
          version: "1.0.0",
          node_version: process.version,
          platform: process.platform,
          arch: process.arch,
        },
        heartbeat: {
          status: "ONLINE",
          last_beat: new Date().toISOString(),
          uptime_seconds: 0
        },
        nodes: {
          "Telemetry-Heart": { status: "Activo", last_update: new Date().toISOString() },
          "Gerrit-Client": { status: "Pendiente", last_update: null },
          "Agente CustomTools": { status: "Activo", last_update: new Date().toISOString() }
        },
        metrics: {
          total_executions: 0,
          errors_count: 0
        }
      };
      await fs.writeFile(STATE_FILE, JSON.stringify(initialState, null, 2), 'utf-8');
      await this.log("INFO", "state.json inicializado correctamente.");
    }
  }

  async readState() {
    try {
      const data = await fs.readFile(STATE_FILE, 'utf-8');
      return JSON.parse(data);
    } catch (err) {
      await this.log("ERROR", `Error leyendo ${STATE_FILE}: ${err.message}`);
      return null;
    }
  }

  async updateState(updaterFn) {
    try {
      const currentState = await this.readState();
      if (!currentState) return;

      const updatedState = updaterFn(currentState);
      
      const tempFile = `${STATE_FILE}.tmp`;
      await fs.writeFile(tempFile, JSON.stringify(updatedState, null, 2), 'utf-8');
      await fs.rename(tempFile, STATE_FILE);
    } catch (err) {
      await this.log("ERROR", `Error actualizando el estado: ${err.message}`);
    }
  }

  async updateNodeStatus(nodeName, status, details = {}) {
    await this.updateState((state) => {
      if (!state.nodes) state.nodes = {};
      state.nodes[nodeName] = {
        status: status,
        last_update: new Date().toISOString(),
        ...details
      };
      return state;
    });
    await this.log("INFO", `Nodo '${nodeName}' actualizado a estado: ${status}`);
  }

  async beat() {
    const uptime = process.uptime();
    await this.updateState((state) => {
      state.heartbeat = {
        status: "ONLINE",
        last_beat: new Date().toISOString(),
        uptime_seconds: Math.floor(uptime)
      };
      if (state.nodes["Telemetry-Heart"]) {
        state.nodes["Telemetry-Heart"].last_update = new Date().toISOString();
      }
      return state;
    });
    await this.log("DEBUG", `Heartbeat emitido. Uptime: ${Math.floor(uptime)}s`);
  }

  async start() {
    await this.init();
    await this.updateNodeStatus("Telemetry-Heart", "Activo");
    await this.beat();

    this.timer = setInterval(async () => {
      await this.beat();
    }, this.intervalMs);

    await this.log("INFO", `Telemetry-Heart iniciado con intervalo de ${this.intervalMs}ms`);
  }

  async stop() {
    if (this.timer) clearInterval(this.timer);
    await this.updateNodeStatus("Telemetry-Heart", "Detenido");
    await this.log("INFO", "Telemetry-Heart detenido.");
  }

  async log(level, message) {
    const timestamp = new Date().toISOString();
    const line = `[${timestamp}] [${level}] ${message}\n`;
    try {
      await fs.appendFile(LOG_FILE, line, 'utf-8');
    } catch (err) {
      console.error("Error escribiendo en log:", err.message);
    }
  }
}

const heart = new TelemetryHeart({ intervalMs: 15000 });
await heart.start();

console.log("Telemetry-Heart ejecutándose... Presiona Ctrl + C para detener.");

process.on('SIGINT', async () => {
  console.log('\nDeteniendo Telemetry-Heart...');
  await heart.stop();
  process.exit(0);
});
