#!/data/data/com.termux/files/usr/bin/bash
# ==================================================
# Script Integrado: Snapshot Global + Sincronización Remota
# Propietario: Ricardo Moran (@ricardomoranbot) | Huella: chrome-mobile-es-419
# ==================================================

SNAPSHOT_DIR="$HOME/proyectos/snapshots"
FECHA_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE="$SNAPSHOT_DIR/snapshot_$TIMESTAMP.json"
BOT_DIR="$HOME/botmoranricardo"

mkdir -p "$SNAPSHOT_DIR"

echo "=== [SNAPSHOT & SYNC] Iniciando captura y respaldo remoto ==="

# 1. Generar la instantánea del ecosistema
cat << JSON_EOF > "$OUTPUT_FILE"
{
  "metadatos": {
    "version_modelo": "1.1.0",
    "timestamp": "$FECHA_ISO",
    "propietario": "@ricardomoranbot",
    "cuenta_github": "@moranricardo",
    "huella_origen": "chrome-mobile-es-419",
    "referencia_academica": "https://dem.colmex.mx/"
  },
  "repositorios_locales": [
    {"nombre": "bot-factory", "ruta": "$HOME/bot-factory"},
    {"nombre": "bot-reportes", "ruta": "$HOME/bot-reportes"},
    {"nombre": "cli", "ruta": "$HOME/cli"},
    {"nombre": "didactic-octo-chrome", "ruta": "$HOME/didactic-octo-chrome"},
    {"nombre": "git-espejo", "ruta": "$HOME/git-espejo"},
    {"nombre": "ia-didactica-core", "ruta": "$HOME/git/ia-didactica-core"},
    {"nombre": "proyecto-nuevo", "ruta": "$HOME/proyecto-nuevo"},
    {"nombre": "puppeteer", "ruta": "$HOME/puppeteer"},
    {"nombre": "ra-pulse-orchestrator", "ruta": "$HOME/git/ra-pulse-orchestrator"},
    {"nombre": "skills-copilot-codespaces-vscode", "ruta": "$HOME/skills-copilot-codespaces-vscode"},
    {"nombre": "temp-puppeteer", "ruta": "$HOME/temp-puppeteer"},
    {"nombre": "work-assets", "ruta": "$HOME/work/assets"},
    {"nombre": "scaling-meme", "ruta": "$HOME/scaling-meme"}
  ],
  "scripts_sistema": [
    "export-ctx.sh",
    "gemini.sh",
    "update_workflow.sh",
    "sync-botmoranricardo.sh",
    "ciclo_dem_core.sh",
    "snapshot-ecosistema.sh",
    "snapshot-y-sync.sh"
  ],
  "artefactos_estado": {
    "entrada_json": "$HOME/entrada.json",
    "resultado_json": "$HOME/resultado.json",
    "auditoria_bot": "$HOME/botmoranricardo/auditoria_bot.log",
    "sello_propiedad": "$HOME/botmoranricardo/sello_propiedad.json"
  }
}
JSON_EOF

echo "[SNAPSHOT] Instantánea creada en: $OUTPUT_FILE"

# 2. Sincronizar con el Nodo Propietario o Repositorio de Reportes
if [ -d "$BOT_DIR/.git" ]; then
  echo "[SYNC] Copiando snapshot al nodo propietario botmoranricardo..."
  cp "$OUTPUT_FILE" "$BOT_DIR/sello_snapshot.json"
  
  cd "$BOT_DIR" || exit 1
  git add sello_snapshot.json
  git commit -m "chore(@ricardomoranbot): sincronización automática snapshot $TIMESTAMP [skip ci]" 2>/dev/null || echo "[SYNC] Sin cambios nuevos para commitear."
  
  if git remote | grep -q "origin"; then
    echo "[SYNC] Empujando cambios al repositorio remoto..."
    git push origin master 2>/dev/null || git push origin main 2>/dev/null || echo "[SYNC] Push omitido o sin conectividad remota activa."
  else
    echo "[SYNC] Nodo propietario configurado en modo local."
  fi
fi

echo "=== [SNAPSHOT & SYNC] Ciclo completado con éxito ==="
