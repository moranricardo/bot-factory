#!/bin/bash

REPOS=(
  "$HOME/ia-didactica-core"
  "$HOME/git-espejo"
  "$HOME/git/ra-pulse-orchestrator"
  "$HOME/bot-factory"
  "$HOME/bot-reportes"
  "$HOME/cli"
  "$HOME/didactic-octo-chrome"
  "$HOME/proyecto-nuevo"
  "$HOME/puppeteer"
  "$HOME/skills-copilot-codespaces-vscode"
  "$HOME/scaling-meme"
  "$HOME/work/assets"
)

echo "=== 🔄 Auto-Sync con GitHub: $(date) ==="

for REPO in "${REPOS[@]}"; do
  if [ -d "$REPO/.git" ]; then
    cd "$REPO" || continue
    if [[ -n $(git status -s) ]]; then
      echo "📁 Guardando cambios locales en: $REPO"
      git add -A
      git commit -m "chore(auto-sync): respaldo automatico $(date +'%Y-%m-%d %H:%M')"
    fi
    git pull --rebase origin main 2>/dev/null || git pull --rebase origin master 2>/dev/null
    git push origin main 2>/dev/null || git push origin master 2>/dev/null
  fi
done

echo "✅ Todos los repositorios sincronizados."
