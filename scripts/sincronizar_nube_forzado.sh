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

echo "=== [NUBE SEGURA] Sincronización con integración remota (@moranricardo) ==="

for repo in "${REPOS[@]}"; do
  if [ -d "$repo/.git" ]; then
    cd "$repo" || continue
    nombre=$(basename "$repo")
    echo "--------------------------------------------------"
    echo "🚀 Procesando e integrando: $nombre"
    
    # Limpiar rastros de node_modules por si acaso
    git rm -r --cached node_modules 2>/dev/null || true
    
    if [[ -n $(git status -s) ]]; then
      git add .
      git commit -m "chore(sync): sincronización y blindaje local [chrome-mobile-es-419]" || true
    fi
    
    rama=$(git branch --show-current 2>/dev/null || echo "main")
    
    # Integrar cambios remotos de forma segura antes del push
    git pull origin "$rama" --rebase --autostash || echo "⚠️ Aviso: No se pudo hacer rebase automático en $nombre (continuando...)"
    
    # Enviar a la nube
    git push origin "$rama" || echo "⚠️ Aviso: Verifique el estado remoto de $nombre."
  fi
done

echo "================================================--"
echo "🎉 [ÉXITO] Sincronización robusta finalizada."
