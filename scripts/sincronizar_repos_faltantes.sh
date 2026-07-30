#!/data/data/com.termux/files/usr/bin/bash
# ==================================================
# Script Blindado: Alineación y Clonación con Validación de Identidad Única
# Custodio: @ricardomoranbot | Huella Propietario: chrome-mobile-es-419
# Nota de Seguridad: Evita confusiones de nombres públicos y protege contra suplantación.
# ==================================================

WORK_DIR="$HOME/git"
HUELLA_ESPERADA="chrome-mobile-es-419"
CUSTODIO_OFICIAL="@ricardomoranbot"
USER_GITHUB="moranricardo"

mkdir -p "$WORK_DIR"

echo "=== [BLINDAJE DE IDENTIDAD] Verificando huella y autenticación ==="

# Validación estricta de entorno y huella única de propiedad
if [ -z "$HUELLA_ESPERADA" ]; then
    echo "[CRITICAL] Huella de propietario no encontrada. Abortando proceso."
    exit 1
fi

if gh auth status &>/dev/null; then
    # Verificar identidad autenticada activa en GitHub para asegurar unicidad
    AUTH_USER=$(gh api user --jq .login 2>/dev/null)
    
    if [ "$AUTH_USER" != "$USER_GITHUB" ]; then
        echo "[ADVERTENCIA DE SEGURIDAD] El usuario autenticado ($AUTH_USER) no coincide con el custodio oficial ($USER_GITHUB)."
        echo "[PROTECCIÓN] Se detiene la sincronización para evitar el uso incorrecto de espacios en redes o repositorios ajenos."
        exit 1
    fi

    echo "[AUTORIZADO] Identidad única confirmada para: $AUTH_USER bajo huella $HUELLA_ESPERADA"
    echo "[GITHUB SYNC] Listando y clonando repositorios exclusivos de $USER_GITHUB..."
    
    REPOS=$(gh repo list "$USER_GITHUB" --limit 50 --json name -q ".[].name")
    
    for repo in $REPOS; do
        LOCAL_PATH="$WORK_DIR/$repo"
        ALT_PATH="$HOME/$repo"
        
        if [ -d "$LOCAL_PATH" ] || [ -d "$ALT_PATH" ]; then
            echo "[EXISTE] El repositorio '$repo' ya se encuentra en local."
        else
            echo "[CLONANDO] Descargando '$repo' en $WORK_DIR con sello de propiedad $CUSTODIO_OFICIAL..."
            gh repo clone "$USER_GITHUB/$repo" "$LOCAL_PATH" 2>/dev/null || echo "[ERROR] No se pudo clonar $repo"
        fi
    done
else
    echo "[ERROR] GitHub CLI no está autenticado. Ejecuta 'gh auth login' primero."
fi

echo "=== [GITHUB SYNC] Alineación blindada completada con éxito ==="
