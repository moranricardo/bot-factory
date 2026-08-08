/**
 * Módulo de scraping / obtención de datos ligero.
 * Utiliza fetch nativo de Node.js.
 */
async function scrape(url = 'https://www.chromium.org') {
  try {
    console.log(`🌍 Obteniendo datos de: ${url}`);
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const text = await response.text();
    // Extracción básica de título vía Regex
    const match = text.match(/<title>(.*?)<\/title>/i);
    const title = match ? match[1] : "Sin título";
    return title;
  } catch (error) {
    console.error("❌ Error en el scraping ligero:", error.message);
    return null;
  }
}

async function vorticePrincipal() {
  console.log("[VÓRTICE 818] Iniciando escaneo de mercados...");
  const datos = await scrape();
  console.log("Titulares encontrados:", datos);
}

module.exports = { scrape, vorticePrincipal };
