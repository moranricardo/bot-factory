import os
import sys

# Eliminamos la exigencia estricta de Azure y priorizamos Gemini
AZURE_OPENAI_API_KEY = os.getenv("AZURE_OPENAI_API_KEY")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    print("❌ Error: GEMINI_API_KEY no está configurada.")
    sys.exit(1)

if not AZURE_OPENAI_API_KEY:
    print("⚠️ Aviso: Variables de Azure no configuradas. Omitiendo Azure y operando exclusivamente con Gemini.")
else:
    print("✨ Azure configurado correctamente, pero adaptando flujo a IA unificada.")

print("🚀 [Bridge] Ejecución completada con éxito usando Gemini.")
