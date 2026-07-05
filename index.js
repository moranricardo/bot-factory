const https = require('https');
const fs = require('fs');

// URL mutada: Ampliamos el espectro a 25 cambios para seleccionar los mejores "genes"
const GERRIT_URL = 'https://review.lineageos.org/changes/?q=status:open&n=25';
const OUTPUT_PATH = 'data/gerrit_payload.json';

console.log('📡 [Ra Pulse: Selección Local] Escaneando LineageOS...');

https.get(GERRIT_URL, (res) => {
    let data = '';
    res.on('data', (chunk) => { data += chunk; });
    res.on('end', () => {
        try {
            const PREFIJO_XSS = ")]}'\n";
            let jsonLimpio = data;
            
            if (data.startsWith(PREFIJO_XSS)) {
                jsonLimpio = data.slice(PREFIJO_XSS.length);
            }

            const todosLosCambios = JSON.parse(jsonLimpio);
            
            // FILTRO DE MUTACIÓN: Seleccionar solo parches de seguridad o fixes críticos
            const palabrasClave = ['security', 'cve', 'fix', 'vulnerability', 'kernel', 'patch'];
            const cambiosMutados = todosLosCambios.filter(cambio => {
                const asunto = cambio.subject ? cambio.subject.toLowerCase() : '';
                return palabrasClave.some(palabra => asunto.includes(palabra));
            });

            console.log(`🛡️ [Filtro Maat] Estructura limpia analizada.`);
            console.log(`🧬 [Evolución] De ${todosLosCambios.length} cambios analizados, se aislaron ${cambiosMutados.length} injertos críticos.`);

            // Si el filtro es demasiado estricto, dejamos al menos los 3 más recientes para no dejar vacía la cadena
            const payloadFinal = cambiosMutados.length > 0 ? cambiosMutados : todosLosCambios.slice(0, 3);

            fs.writeFileSync(OUTPUT_PATH, JSON.stringify(payloadFinal, null, 2));
            console.log(`💾 Telemetria evolutiva guardada en: ${OUTPUT_PATH}`);

        } catch (error) {
            console.error('❌ Error en el proceso de aislamiento:', error.message);
        }
    });
}).on('error', (err) => {
    console.error('❌ Error de enlace:', err.message);
});
