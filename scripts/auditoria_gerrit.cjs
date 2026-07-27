const https = require('https');

// Cambia 'tu-gerrit-url-aqui' por la URL real
const GERRIT_API_URL = 'https://gerrit.example.com'; 

function fetchGerritChanges() {
    https.get(`${GERRIT_API_URL}/changes/?q=status:open`, (res) => {
        let rawData = '';

        res.on('data', (chunk) => { rawData += chunk; });

        res.on('end', () => {
            try {
                const cleanData = rawData.replace(/^\)]\}'\n/, '');
                const changes = JSON.parse(cleanData);
                console.log('Pulso del sistema: Cambios activos:', changes.length);
            } catch (e) {
                console.error('Error en el parsing:', e.message);
            }
        });
    }).on('error', (err) => {
        console.error('Error de red:', err.message);
    });
}

fetchGerritChanges();

