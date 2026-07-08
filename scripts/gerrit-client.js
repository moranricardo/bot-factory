async function fetchGerritChanges() {
  try {
    const response = await fetch('https://review.lineageos.org/changes/?q=status:open');
    let rawBody = await response.text();
    
    // Protocolo de saneamiento estricto: Eliminar prefijo )]}'\n
    const sanitizedBody = rawBody.replace(/^\)\]\}'\n/, '');
    
    const data = JSON.parse(sanitizedBody);
    console.log("[Gerrit-Client] Datos procesados con éxito:", data.length, "cambios.");
    return data;
  } catch (err) {
    console.error("[Gerrit-Client] Error fatal:", err.message);
    process.exit(1);
  }
}

fetchGerritChanges();

