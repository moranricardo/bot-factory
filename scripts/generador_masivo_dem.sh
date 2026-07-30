#!/data/data/com.termux/files/usr/bin/bash
set -e

# Lista de palabras objetivo para la generación masiva de lecciones
PALABRAS=("Sintetizar" "Ecosistema" "Algoritmo" "Automatización" "Orquestación")
CORE_LECCIONES="$HOME/git/ia-didactica-core/lecciones"
EXTRACTOR_DIR="$HOME/extractor-dem-core"

mkdir -p "$CORE_LECCIONES"
cd "$EXTRACTOR_DIR" || exit

echo "=== [GENERADOR MASIVO] Iniciando procesamiento de $(echo ${PALABRAS[@]} | wc -w) palabras ==="

for palabra in "${PALABRAS[@]}"; do
    TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")
    ARCHIVO_LECCION="$CORE_LECCIONES/leccion_dem_${palabra,,}_${TIMESTAMP}.md"
    
    echo "------------------------------------------------------------------"
    echo "📚 Generando lección base para: '$palabra'"
    
    # Crear estructura base de la lección Markdown
    cat << MARKDOWN > "$ARCHIVO_LECCION"
# 📖 Lección Didáctica: ${palabra}

## 🎯 Objetivo de Aprendizaje
Comprender y aplicar el concepto de **${palabra}** dentro del ecosistema de desarrollo automatizado e ingeniería de software.

## 📚 Definición Base (DEM Colmex)
> *Espacio reservado para la extracción automatizada de la definición de '${palabra}'.*
> **Consulta directa:** [Ver entrada en el DEM](https://dem.colmex.mx/app/Busqueda/BuscarEnDiccionario?q=${palabra})

## 🛠️ Aplicación Práctica en el Ecosistema
Esta lección se integra de manera autónoma con los flujos de trabajo locales bajo la huella **chrome-mobile-es-419**.
MARKDOWN

    # Ejecutar el extractor ligero (Node.js + Cheerio) para inyectar la definición real
    node extractor_dem.cjs "$palabra" "$ARCHIVO_LECCION"
    
    echo "✅ Lección guardada e inyectada: $(basename "$ARCHIVO_LECCION")"
    sleep 1 # Pausa breve para cortesía con el servidor remoto
done

echo "=================================================================="
echo "🎉 [ÉXITO] Generación masiva completada. Lecciones sincronizadas en ia-didactica-core."
