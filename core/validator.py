import os
import sys

# Diccionario de control anti-mutativo extendido (POD v1.0)
MUTATION_DICTIONARY = {
    "directories": [
        os.path.expanduser('~/logs'),
        os.path.expanduser('~/data'),
        os.path.expanduser('~/temp-lib')
    ],
    "forbidden_extensions": [".log", ".json", ".tmp", ".mjs"],
    "allowed_exceptions": ["README.md", "ra-pulse-bridge.yml"],
    "root_whitelist": ["update_workflow.sh", "export-ctx.sh", "gemini.sh", ".bashrc", ".gitconfig"]
}

def check_local_storage():
    violations = []
    
    # 1. Escaneo de directorios prohibidos según el diccionario
    for target_dir in MUTATION_DICTIONARY["directories"]:
        if os.path.exists(target_dir):
            try:
                items = os.listdir(target_dir)
                for item in items:
                    item_path = os.path.join(target_dir, item)
                    if os.path.isfile(item_path):
                        if item not in MUTATION_DICTIONARY["allowed_exceptions"]:
                            violations.append(item_path)
            except Exception as e:
                pass

    # 2. Escaneo de artefactos sueltos no permitidos en la raíz de trabajo (~/)
    home_dir = os.path.expanduser('~/')
    try:
        for file_name in os.listdir(home_dir):
            file_path = os.path.join(home_dir, file_name)
            if os.path.isfile(file_path):
                ext = os.path.splitext(file_name)[1]
                if ext in MUTATION_DICTIONARY["forbidden_extensions"]:
                    if file_name not in MUTATION_DICTIONARY["root_whitelist"]:
                        violations.append(file_path)
    except Exception as e:
        pass

    return violations

def validate_environment():
    violations = check_local_storage()
    if violations:
        print("[!] 🚨 ALERTA ROJA [Mutación Detectada]: Archivos ilegales en almacenamiento interno (Violación POD v1.0):")
        for v in violations:
            print(f"    - Obstrucción en diccionario activo: {v}")
        print("[!] Acción requerida: Ejecutar purga inmediata o sincronizar con SSoT en GitHub (@moranricardo).")
        return False
    else:
        print("[antiflow+] Validador Capa 3: Cero rastros en diccionarios de mutación. Integridad del POD v1.0 intacta.")
        return True

if __name__ == "__main__":
    success = validate_environment()
    sys.exit(0 if success else 1)
