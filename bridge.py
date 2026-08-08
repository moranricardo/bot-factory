import json
import subprocess
from agente_custom import AgenteCustomTools

def auditar_proyecto_nuevo():
    try:
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
