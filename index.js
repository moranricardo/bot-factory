const { scrape } = require('./modules/scraping.js');
const fs = require('fs');
const path = require('path');

async function run() {
  console.log("🚀 Iniciando el pulso del Ciclo de Ra...");

  try {
    const titulo = await scrape('https://example.com');
    console.log(`🔗 Conexión exitosa. Título obtenido: ${titulo}`);

    const configPath = path.join(__dirname, 'config', 'state.json');
    const state = {
      lastPulse: new Date().toISOString(),
      status: "HEALTHY",
      lastScrapedTitle: titulo
    };

    fs.writeFileSync(configPath, JSON.stringify(state, null, 2));
    console.log("📊 Telemetría actualizada en config/state.json");

  } catch (error) {
    console.error("❌ Error en el ciclo:", error.message);
  }
}

run();
