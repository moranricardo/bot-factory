const https = require('https');
const fs = require('fs');

const GERRIT_URL = 'https://review.lineageos.org/changes/?q=status:open&n=5';
const OUTPUT_PATH = 'data/gerrit_payload.json';

console.log('📡 [Gerrit-Client] Conectando con LineageOS...');

https.get(GERRIT_URL, (res) => {
    let data = '';

    res.on('data', (chunk) => { data += chunk; });

    res.on('end', () => {
        try {
            // PROTOCOLO MAAT: Limpieza estricta del prefijo anti-XSS de Gerrit
            const PREFIJO_XSS = ")]}'\n";
            let jsonLimpio = data;
            
            if (data.startsWith(PREFIJO_XSS)) {
                jsonLimpio = data.slice(PREFIJO_XSS.length);
                console.log('🛡️ [Filtro Maat] Prefijo anti-XSS detectado y removido con exito.');
            }

            // Validar y parsear la telemetría
            const listaCambios = JSON.parse(jsonLimpio);
            console.log(`✅ [Gerrit-Client] Se recuperaron ${listaCambios.length} cambios abiertos.`);

            // Guardar localmente para sincronizar el estado
            fs.writeFileSync(OUTPUT_PATH, JSON.stringify(listaCambios, null, 2));
            console.log(`💾 Telemetria guardada localmente en: ${OUTPUT_PATH}`);

        } catch (error) {
            console.error('❌ Error al procesar o parsear la respuesta de Gerrit:', error.message);
        }
    });

}).on('error', (err) => {
    console.error('❌ Error de conexion HTTPS:', err.message);
});
