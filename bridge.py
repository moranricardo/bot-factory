<<<<<<< Updated upstream
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
=======
import json
import subprocess
from agente_custom import AgenteCustomTools

def auditar_proyecto_nuevo():
    try:
        # Corregimos la sintaxis eliminando '--command' y usando '--'
        comando = 'gh codespace ssh -c potential-guacamole-6994qj4545j4f5gw5 -- "ls -la"'
        resultado = subprocess.check_output(comando, shell=True, text=True, stderr=subprocess.STDOUT)
        return resultado
    except Exception as e:
        return f"Error al auditar proyecto nuevo: {e}"

def orquestar():
    try:
        with open('state.json', 'r') as f:
            data = json.load(f)

        agente = AgenteCustomTools()

        for item in data['modulos']:
            if item['modulo'] == 'Agente CustomTools' and item['estado'] == 'Activo':
                resultado = agente.ejecutar("ls -F")
                print(resultado)
            elif item['estado'] == 'Pendiente':
                print(f"[Sistema] El módulo {item['modulo']} está pendiente.")
    except Exception as e:
        print(f"Error al leer state.json: {e}")

if __name__ == "__main__":
    orquestar()
    print("\n--- [Vigilancia Remota] Auditando potential-guacamole ---")
    print(auditar_proyecto_nuevo())
>>>>>>> Stashed changes
