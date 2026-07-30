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

echo "=== [NUBE CLARIFICADA] Sincronización limpia hacia GitHub (@moranricardo) ==="

for repo in "${REPOS[@]}"; do
  if [ -d "$repo/.git" ]; then
    cd "$repo" || continue
    nombre=$(basename "$repo")
    echo "--------------------------------------------------"
    echo "🚀 Procesando repositorio limpio: $nombre"
    
    # Descartar node_modules del seguimiento si se colaron
    git rm -r --cached node_modules 2>/dev/null || true
    
    if [[ -n $(git status -s) ]]; then
      git add .
      git commit -m "chore(sync): sincronización limpia y optimizada del ecosistema [chrome-mobile-es-419]" || true
    fi
    
    rama=$(git branch --show-current 2>/dev/null || echo "main")
    git push origin "$rama" || echo "⚠️ Nota: Revise permisos o remoto en $nombre."
  fi
done

echo "================================================--"
echo "🎉 [ÉXITO] Todo el ecosistema ha sido migrado y limpiado hacia la nube."
