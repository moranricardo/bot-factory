const https = require('https');
const fs = require('fs');
const path = require('path');

const GERRIT_HOST = 'review.lineageos.org'; 
const ENDPOINT = '/changes/?q=status:open&n=5'; 

const options = {
  hostname: GERRIT_HOST,
  path: ENDPOINT,
  method: 'GET',
  headers: { 'Accept': 'application/json' }
};

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });

  res.on('end', () => {
    try {
      const GERRIT_PREFIX = ")]}'\n";
      let cleanData = data;
      
      if (data.startsWith(GERRIT_PREFIX)) {
        cleanData = data.slice(GERRIT_PREFIX.length);
      }

      // Validar que sea un JSON correcto antes de guardar
      const jsonResponse = JSON.parse(cleanData);
      
      // Definir la ruta de salida
      const outputDir = path.join(__dirname, '../data');
      if (!fs.existsSync(outputDir)){
          fs.mkdirSync(outputDir, { recursive: true });
      }
      
      const outputPath = path.join(outputDir, 'gerrit_payload.json');
      fs.writeFileSync(outputPath, JSON.stringify(jsonResponse, null, 2));
      
      console.log('--- COGNICIÓN LOCAL EXITOSA ---');
      console.log(`✅ Datos guardados localmente en: ${outputPath}`);
      console.log('Ejecuta la sincronización (git push) para activar a Gemini en la nube.');
      
    } catch (error) {
      console.error('❌ Error al procesar la respuesta de Gerrit:', error.message);
    }
  });
});

req.on('error', (e) => {
  console.error(`❌ Error en la petición HTTP: ${e.message}`);
});

req.end();

