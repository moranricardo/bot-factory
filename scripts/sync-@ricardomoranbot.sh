#!/data/data/com.termux/files/usr/bin/bash
set -e

# ==================================================
# Script de sincronización y control para @ricardomoranbot
# Huella Propietario: $chrome-mobile-es-419
# Propietario: Ricardo Moran
# ==================================================

BOT_DIR="$HOME/@ricardomoranbot"
CORE_DIR="$HOME/git/ia-didactica-core"
FECHA_ISO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
FECHA_LOCAL=$(date +"%Y-%m-%d %H:%M:%S %Z")
HUELLA="$chrome-mobile-es-419"
PROPIETARIO="Ricardo Moran"
BOT_ID="ricardomoranbot"

echo "=== [@$BOT_ID | $HUELLA] Iniciando ciclo: $FECHA_LOCAL ==="

# 1. Asegurar existencia del directorio del bot
if [! -d "$BOT_DIR" ]; then
  echo "[INIT] Creando $BOT_DIR"
  mkdir -p "$BOT_DIR"
  cd "$BOT_DIR"
  git init
  git config user.name "$BOT_ID"
  git config user.email "moranricardo@users.noreply.github.com"

  cat > README.md << README_EOF
# Bot Propietario: @$BOT_ID

Nodo de control y enlace para la gestión de reportes y automatización.

## 🛡️ Sello de Propiedad Intelectual

* **Propietario:** $PROPIETARIO
* **Bot Custodio:** @$BOT_ID
* **Huella de Dispositivo:** \`\$chrome-mobile-es-419\`
* **ID de Huella:** $HUELLA
* **Origen:** IA-Didactica-Core Cloud Pipeline
* **Creado:** $FECHA_ISO

> Este nodo es la raíz de control de @$BOT_ID. Cualquier clon sin esta huella es copia no autorizada.

### Estructura
- \`core-link/\` -> $CORE_DIR
- \`entrada.json\` -> Contexto de entrada
- \`auditoria_bot.log\` -> Trazabilidad de ciclos

\`\`\`json
{"owner":"$PROPIETARIO","bot":"$BOT_ID","huella":"\$chrome-mobile-es-419","created":"$FECHA_ISO"}
\`\`\`
README_EOF

  cat >.gitignore << 'GITIGNORE'
entrada.json
resultado.json
*.tmp
*.log
!auditoria_bot.log
GITIGNORE

  mkdir -p.github
  cat >.github/CODEOWNERS << CODEOWNERS
# Sello de Propiedad Intelectual - $chrome-mobile-es-419
# Propietario: Ricardo Moran
* @ricardomoranbot
lecciones/* @ricardomoranbot
.github/* @ricardomoranbot
src/* @ricardomoranbot
CODEOWNERS

  git add.
  git commit -m "feat(@$BOT_ID): inicializacion con sello $HUELLA [propiedad]"
fi

cd "$BOT_DIR"

# 2. Enlazar artefactos clave
echo "[LINK] Enlazando artefactos..."
ln -sfn ~/entrada.json./entrada.json 2>/dev/null || true
ln -sfn ~/resultado.json./resultado.json 2>/dev/null || true
ln -sfn "$CORE_DIR"./core-link 2>/dev/null || true

# 3. Capturar contexto actual
if [ -f "$HOME/scripts/export-ctx.sh" ]; then
  echo "[CTX] Exportando contexto..."
  "$HOME/scripts/export-ctx.sh" "$CORE_DIR" 2>/dev/null || true
  echo "Contexto del núcleo exportado."
fi

# 4. Registrar estado + huella
{
  echo "----------------------------------------"
  echo "Ciclo: $FECHA_LOCAL | ISO: $FECHA_ISO"
  echo "Huella: $HUELLA | Bot: @$BOT_ID"
  echo "Propietario: $PROPIETARIO"
  echo "Core: $CORE_DIR [$(cd "$CORE_DIR" && git rev-parse --short HEAD 2>/dev/null || echo 'no-git')]"
  echo "Bateria: $(termux-battery-status 2>/dev/null | grep -o '"percentage": [0-9]*' | grep -o '[0-9]*' || echo 'N/A')%"
} >> auditoria_bot.log

# 5. Sello JSON trazable
cat > sello_propiedad.json << JSON_EOF
{
  "owner": "$PROPIETARIO",
  "bot": "@$BOT_ID",
  "huella": "\$chrome-mobile-es-419",
  "huella_id": "$HUELLA",
  "timestamp": "$FECHA_ISO",
  "local": "$FECHA_LOCAL",
  "core_commit": "$(cd "$CORE_DIR" && git rev-parse HEAD 2>/dev/null || echo 'no-commit')",
  "bot_path": "$BOT_DIR"
}
JSON_EOF

# 6. Git commit y push
git add -A
if! git diff --cached --quiet; then
  git commit -m "chore(@$BOT_ID): ciclo $FECHA_ISO | huella $HUELLA [skip ci]

Propiedad: $PROPIETARIO
Huella: \$chrome-mobile-es-419
Archivo: sello_propiedad.json
Core: $(cd "$CORE_DIR" && git rev-parse --short HEAD 2>/dev/null || echo 'N/A')"

  # Push solo si hay remoto
  if git remote | grep -q origin; then
    git push origin main 2>&1 | sed 's/.*/[GIT] &/' || echo "[GIT] Sin conexión o sin cambios remotos"
  else
    echo "[GIT] Sin remoto configurado - solo local"
  fi
else
  echo "[GIT] Sin cambios en @$BOT_ID"
fi

echo "=== [@$BOT_ID | $HUELLA] Ciclo finalizado con éxito ==="
echo "📄 Log: $BOT_DIR/auditoria_bot.log"
echo "🛡️ Sello: $BOT_DIR/sello_propiedad.json"
