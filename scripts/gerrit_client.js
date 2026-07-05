const https = require('https');
const fs = require('fs');

const cookieFile = fs.readFileSync(process.env.HOME + '/.gitcookies', 'utf8');
const line = cookieFile.split('\n').find(l => l.includes('chromium-review'));
const cookieValue = line.split('\t').pop();

const options = {
    hostname: 'chromium-review.googlesource.com',
    path: '/a/changes/?q=status:open',
    method: 'GET',
    headers: { 'User-Agent': 'Node-Bot-Factory', 'Cookie': 'o=' + cookieValue }
};

https.request(options, (res) => {
    let data = '';
    res.on('data', (c) => data += c);
    res.on('end', () => {
        // Protocolo Maat: Limpieza del prefijo de seguridad )]}'
        const jsonString = data.replace(/^\)\]\}'\n/, '');
        try {
            const changes = JSON.parse(jsonString);
            console.log(`Auditoría completa: Se encontraron ${changes.length} cambios.`);
            changes.forEach((c, i) => {
                console.log(`${i + 1}. [${c.change_id.substring(0, 8)}] ${c.subject}`);
            });
        } catch (e) {
            console.error('Error al procesar JSON:', e.message);
        }
    });
}).on('error', (e) => console.error(e)).end();

