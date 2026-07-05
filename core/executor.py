import os
import sys

def transmute(file_path):
    if not os.path.exists(file_path):
        return f"Error: Nodo {file_path} no localizado en el espacio físico."
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Simulación de transmutación: Transformación de texto plano a lógica procesable
    print(f"--- [DRENAJE DE INFORMACIÓN: {file_path}] ---")
    print(content)
    print("--- [TRANSUMTACIÓN FINALIZADA: Axiomas absorbidos por el Core] ---")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        transmute(sys.argv[1])
    else:
        print("Uso: python core/executor.py <ruta_del_nodo>")
