import json
import subprocess
from agente_custom import AgenteCustomTools

def auditar_proyecto_nuevo():
    try:
        # Esto intenta conectar con el otro contenedor (turbo-xylophone)
        comando = 'gh codespace ssh -c "turbo-xylophone" --command "ls -la"'
        resultado = subprocess.check_output(comando, shell=True, text=True)
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
    # 1. Ejecuta tu pulso principal sin alteraciones
    orquestar()
    
    # 2. Descomenta las siguientes dos líneas (quitando el #) cuando 
    # estés listo para probar la vigilancia remota de la Evolución Pro:
    
    print("\n--- [Vigilancia Remota] Auditando turbo-xylophone ---")
    print(auditar_proyecto_nuevo())
