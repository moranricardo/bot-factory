#!/data/data/com.termux/files/usr/bin/bash
# PROTOCOLO: Inyección directa a GitHub sin guardar local

REPO_PATH="$1"
FILE_PATH="$2"
MSG="$3"

if [ -z "$REPO_PATH" ] || [ -z "$FILE_PATH" ]; then
  echo "Uso: ~/inject.sh <ruta_repo> <archivo_a_subir> <mensaje>"
  exit 1
fi

cd "$REPO_PATH"
# Comprime todo en 1 commit
git add "$FILE_PATH"
git commit -m "$MSG [termux-inject]"
git push origin main --force-with-lease

# Limpieza RAM inmediata - borra archivo del cache de git
echo "✅ Inyectado. Limpieza de memoria RAM local..."
git gc --prune=now --aggressive
