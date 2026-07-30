#!/bin/bash

# ======================================================================
# RA PULSE - RADIO EXTENSIÓN: GEMINI API CLIENT (LIGHTWEIGHT)
# ======================================================================

# Forzar la lectura estricta desde la variable de entorno
if [ -z "$GEMINI_API_KEY" ]; then
    echo "❌ Error de Telemetría: La variable \$GEMINI_API_KEY no está definida."
    echo "Por favor, ejecute: export GEMINI_API_KEY=\"tu_clave_aquí\" o agréguela a su ~/.bashrc"
    exit 1
fi

API_KEY="$GEMINI_API_KEY"
MODEL="gemini-2.5-flash"
URL="https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent?key=$API_KEY"

# Validación de argumentos de entrada (El Espantapájaros: Resolución Pura)
if [ -z "$1" ]; then
    echo "❌ Error de Sintaxis: Debes proporcionar un prompt como argumento."
    echo "Uso: ./gemini.sh \"Tu instrucción aquí\""
    exit 1
fi

# Construcción segura del JSON usando jq (Mitigación de Inyecciones)
JSON_PAYLOAD=$(jq -n --arg prompt "$1" '{contents: [{parts: [{text: $prompt}]}]}')

# Ejecución ligera mediante curl hacia la API REST
RESPONSE=$(curl -s $URL \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "$JSON_PAYLOAD")

# Extraer el pulso de la respuesta de forma segura
TEXT_OUT=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text // empty')

if [ -z "$TEXT_OUT" ]; then
    echo "❌ Error en el Duat: La API de Google no devolvió un formato válido o la clave expiró."
    echo "Detalle del error:"
    echo "$RESPONSE" | jq '.'
    exit 1
else
    echo -e "$TEXT_OUT"
fi
