#!/bin/bash
# =====================================================================
# Script: pulse-monitor.sh (POD v1.0 - S淨T Compliant)
# Descripción: Automatización asíncrona de auditoría y pulso del sistema.
# =====================================================================

TARGET_DIR="$HOME/git/bot-factory"
LOG_FILE="$TARGET_DIR/logs/pulse-audit.log"

mkdir -p "$TARGET_DIR/logs"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] [+] Iniciando pulso asíncrono del sistema..." >> "$LOG_FILE"

if [ -d "$TARGET_DIR" ]; then
    cd "$TARGET_DIR"
    termux-wake-lock 2>/dev/null || true
    ./ra status >> "$LOG_FILE" 2>&1
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [✓] Pulso completado con éxito." >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [!] Error: SSoT bot-factory no encontrada." >> "$LOG_FILE"
fi
