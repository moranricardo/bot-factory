#!/data/data/com.termux/files/usr/bin/bash

# Define la ruta del proyecto dinámicamente (usa el argumento pasado o el directorio actual, o por defecto didactic-octo-chrome)
PROJECT_DIR="${1:-$PWD}"
OUTPUT_DIR="$HOME/storage/shared/Download/Notebook_Contexts"
OUTPUT_FILE="$OUTPUT_DIR/proyecto_contexto.md"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: El directorio del proyecto no existe en $PROJECT_DIR"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "# Contexto de Desarrollo - $(date +%Y-%m-%d)" > "$OUTPUT_FILE"
echo "## Proyecto: $(basename "$PROJECT_DIR")" >> "$OUTPUT_FILE"
echo "## Entorno: Termux sobre Android (ARM)" >> "$OUTPUT_FILE"

# 1. Mapeo de la arquitectura de archivos
echo -e "\n## Estructura del Proyecto" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
cd "$PROJECT_DIR" && find . -maxdepth 3 -not -path '*/.*' -not -path '*node_modules*' >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"

# 2. Volcado del package.json para verificar dependencias
if [ -f "$PROJECT_DIR/package.json" ]; then
    echo -e "\n## package.json" >> "$OUTPUT_FILE"
    echo '```json' >> "$OUTPUT_FILE"
    cat "$PROJECT_DIR/package.json" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
fi

# 3. Empaquetado de scripts fuentes principales
echo -e "\n## Código Fuente" >> "$OUTPUT_FILE"
cd "$PROJECT_DIR"
find . -name "*.js" -not -path '*node_modules*' -not -path '*/.*' | while read -r file; do
    echo -e "\n### Archivo: $file" >> "$OUTPUT_FILE"
    echo '```javascript' >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo '```' >> "$OUTPUT_FILE"
done

echo "Exportación finalizada con éxito para: $(basename "$PROJECT_DIR")"
