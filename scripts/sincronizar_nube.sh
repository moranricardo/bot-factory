#!/data/data/com.termux/files/usr/bin/bash
set -e

REPOS=(
  "$HOME/bot-factory"
  "$HOME/bot-reportes"
  "$HOME/cli"
  "$HOME/didactic-octo-chrome"
  "$HOME/git-espejo"
  "$HOME/git/ia-didactica-core"
  "$HOME/proyecto-nuevo"
  "$HOME/puppeteer"
  "$HOME/git/ra-pulse-orchestrator"
  "$HOME/skills-copilot-codespaces-vscode"
  "$HOME/temp-puppeteer"
  "$HOME/work/assets"
)

echo "=== [NUBE] Iniciando sincronización masiva hacia GitHub (@moranricardo) ==="

for repo in "${REPOS[@]}"; do
  if [ -d "$repo/.git" ]; then
    cd "$repo" || continue
    nombre=$(basename "$repo")
    echo "--------------------------------------------------"
    echo "🚀 Procesando repositorio: $nombre"
    
    # Comprobar si hay cambios sin commitear
    if [[ -n $(git status -s) ]]; then
      git add .
      git commit -m "chore(sync): sincronización automática y blindaje de estado [chrome-mobile-es-419]" || true
    fi
    
    # Obtener la rama actual
    rama=$(git branch --show-current 2>/dev/null || echo "main")
    
    # Intentar hacer push al remoto correspondiente
    git push origin "$rama" || echo "⚠️ Advertencia: No se pudo hacer push directo en $nombre (verificar remote)."
  fi
done

echo "=================================================="
echo "✅ [ÉXITO] Sincronización hacia la nube finalizada."
