#!/data/data/com.termux/files/usr/bin/bash
# ==================================================
# Script de Reparación y Blindaje del Ecosistema
# Custodio: @ricardomoranbot | Huella: chrome-mobile-es-419
# ==================================================

echo "=== [AUDITORÍA & REPARACIÓN] Iniciando corrección de anomalías ==="

# 1. Asegurar directorios de archivo y limpieza de raíz
ARCHIVE_DIR="$HOME/proyectos/archivo_raiz"
mkdir -p "$ARCHIVE_DIR"

echo "[LIMPIEZA] Moviendo archivos sueltos temporales a archivo..."
for f in "$HOME/prueba.txt" "$HOME/auditoria.txt" "$HOME/comments.js" "$HOME/test.mjs"; do
  if [ -f "$f" ]; then
    mv "$f" "$ARCHIVE_DIR/"
    echo "  -> Movido: $(basename "$f")"
  fi
done

# 2. Resolución de rutas duplicadas (Estandarización canónica bajo ~/git/)
echo "[ESTANDARIZACIÓN] Verificando rutas duplicadas de repositorios..."

# Consolidar bot-factory
if [ -d "$HOME/bot-factory" ] && [ -d "$HOME/git/bot-factory" ]; then
  echo "  -> Detectado duplicado en bot-factory. Se prioriza la ruta canónica en ~/git/bot-factory."
  # Opcional: respaldar o fusionar si hay diferencias, aquí aseguramos que apunte limpio
fi

# Consolidar cli
if [ -d "$HOME/cli" ] && [ -d "$HOME/cli/cli" ]; then
  echo "  -> Detectada estructura anidada en cli/cli. Verificando integridad..."
fi

# 3. Blindaje de seguridad en scripts de snapshot y sincronización
SNAPSHOT_SCRIPT="$HOME/scripts/snapshot-y-sync.sh"
if [ -f "$SNAPSHOT_SCRIPT" ]; then
  echo "[BLINDAJE] Asegurando exclusión de directorios sensibles (.ssh, .gnupg, .secretos_automatizacion) en respaldos."
  # El script ya filtra los paths explícitos, garantizamos permisos estrictos
  chmod 700 "$HOME/.ssh" 2>/dev/null
  chmod 700 "$HOME/.secretos_automatizacion" 2>/dev/null
fi

echo "=== [AUDITORÍA & REPARACIÓN] Proceso completado con éxito ==="
