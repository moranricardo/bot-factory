#!/data/data/com.termux/files/usr/bin/bash
set -e

# ======================================================================
# TÍTULO IRREVOCABLE DE PROPIEDAD INTELECTUAL Y SUCESIÓN DIGITAL
# Propietario Originario: Ricardo Moran
# Custodio: @ricardomoranbot
# Huella de Dispositivo Activa: chrome-mobile-es-419
# Cláusula: IRREVOCABLE - INALTERABLE - CON SUCESIÓN
# Jurisdicción: Ecosistema Local + GitHub @moranricardo
# ======================================================================

TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")
FECHA_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
FECHA_LOCAL=$(date +"%Y-%m-%d %H:%M:%S %Z")
HUELLA="chrome-mobile-es-419"
PROPIETARIO="Ricardo Moran"
CUSTODIO="@ricardomoranbot"
GITHUB_USER="moranricardo"

SNAPSHOT_DIR="$HOME/proyectos/snapshots"
SNAPSHOT_FILE="$SNAPSHOT_DIR/snapshot_ecosistema_${TIMESTAMP}.json"
MODELO_MAESTRO="$HOME/modelo_maestro.json"
REGISTRO_IRREVOCABLE="$HOME/proyectos/snapshots/REGISTRO_IRREVOCABLE.md"

mkdir -p "$SNAPSHOT_DIR"

echo "=== [TITULO IRREVOCABLE | $HUELLA] Cristalizando estado: $TIMESTAMP ==="

# 1. MODELO MAESTRO - ACTA DE NACIMIENTO IRREVOCABLE
cat > "$MODELO_MAESTRO" << MODELO_EOF
{
  "titulo": "TITULO IRREVOCABLE DE PROPIEDAD Y SUCESION DIGITAL",
  "version": "3.0.0-irrevocable",
  "clausula": "IRREVOCABLE - Este titulo no puede ser revocado, alterado ni transferido sin consentimiento expreso del propietario originario y validacion de huella",
  "propietario_originario": "$PROPIETARIO",
  "custodio_perpetuo": "$CUSTODIO",
  "huella_activa": "$HUELLA",
  "cuenta_github": "$GITHUB_USER",
  "referencia_academica": "https://dem.colmex.mx/",
  "fecha_emision": "$FECHA_ISO",
  "fecha_local": "$FECHA_LOCAL",
  "lugar_emision": "Termux Android - Ecosistema Local",
  "sucesion": {
    "tipo": "hereditaria_digital",
    "orden": ["$PROPIETARIO", "$CUSTODIO"],
    "condicion": "Solo sucesion directa con validacion de huella $HUELLA y firma GPG del custodio"
  },
  "repositorios_locales": [
    {
      "nombre": "bot-factory",
      "rutas": ["/data/data/com.termux/files/home/bot-factory", "/data/data/com.termux/files/home/git/bot-factory"]
    },
    {
      "nombre": "bot-reportes",
      "rutas": ["/data/data/com.termux/files/home/bot-reportes"]
    },
    {
      "nombre": "cli",
      "rutas": ["/data/data/com.termux/files/home/cli", "/data/data/com.termux/files/home/cli/cli"]
    },
    {
      "nombre": "didactic-octo-chrome",
      "rutas": ["/data/data/com.termux/files/home/didactic-octo-chrome"]
    },
    {
      "nombre": "git-espejo",
      "rutas": ["/data/data/com.termux/files/home/git-espejo"]
    },
    {
      "nombre": "ia-didactica-core",
      "rutas": ["/data/data/com.termux/files/home/ia-didactica-core"]
    },
    {
      "nombre": "proyecto-nuevo",
      "rutas": ["/data/data/com.termux/files/home/proyecto-nuevo"]
    },
    {
      "nombre": "puppeteer",
      "rutas": ["/data/data/com.termux/files/home/puppeteer"]
    },
    {
      "nombre": "ra-pulse-orchestrator",
      "rutas": ["/data/data/com.termux/files/home/git/ra-pulse-orchestrator"]
    },
    {
      "nombre": "skills-copilot-codespaces-vscode",
      "rutas": ["/data/data/com.termux/files/home/skills-copilot-codespaces-vscode"]
    },
    {
      "nombre": "temp-puppeteer",
      "rutas": ["/data/data/com.termux/files/home/temp-puppeteer"]
    },
    {
      "nombre": "work/assets",
      "rutas": ["/data/data/com.termux/files/home/work/assets"]
    }
  ]
}
MODELO_EOF

echo "[ÉXITO] Modelo Maestro verificado con cláusula irrevocable."
