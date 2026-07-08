const fs = require('fs');
const path = require('path');
const STATE_FILE = path.join(__dirname, '../state.json');

function auditSystemPulse() {
    console.log('[Telemetry-Heart] Iniciando auditoría estricta del pulso del sistema...');

    if (!fs.existsSync(STATE_FILE)) {
        const initialState = {
            status: "HEALTHY",
            lastPulse: new Date().toISOString(),
            lastAlert: null,
            metrics: { totalChecks: 0, failures: 0 }
        };
        fs.writeFileSync(STATE_FILE, JSON.stringify(initialState, null, 2));
        return;
    }

    try {
        const state = JSON.parse(fs.readFileSync(STATE_FILE, 'utf8'));
        state.metrics = state.metrics || { totalChecks: 0, failures: 0 };
        state.metrics.totalChecks += 1;
        state.lastPulse = new Date().toISOString();

        if (state.status === 'ERROR') {
            console.warn(`[!] Alerta activa: ${state.lastAlert}`);
        } else {
            console.log(`[Telemetry-Heart] Pulso nominal. Checks: ${state.metrics.totalChecks}`);
        }

        fs.writeFileSync(STATE_FILE, JSON.stringify(state, null, 2));
    } catch (error) {
        console.error(`[Crítico] Fallo en telemetría: ${error.message}`);
        process.exit(1);
    }
}

auditSystemPulse();

