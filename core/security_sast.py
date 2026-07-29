import os
import re
import sys

# Patrones estrictos de búsqueda de secretos reales
SENSITIVE_PATTERNS = [
    r"sk_live_[0-9a-zA-Z]{24,}",
    r"ghp_[0-9a-zA-Z]{36}",
    r"-----BEGIN PRIVATE KEY-----",
    r"api[_-]?key\s*=\s*['\"'][a-zA-Z0-9_\-]{20,}[^'\"]*['\"']"
]

# Directorios a ignorar completamente en el análisis forense/SAST
IGNORE_DIRS = {'node_modules', '.git', 'venv', 'dist', 'build', '.npm-cache', '.cache'}

TARGET_PATH = os.path.expanduser("~/git")

def scan_repository():
    print("[SAST-Engine v1.1] Iniciando análisis estático limpio en repositorios SSoT...")
    findings = 0
    
    for root, dirs, files in os.walk(TARGET_PATH):
        # Modificar dirs in-place para omitir directorios de dependencias y evitar falsos positivos
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
            
        for file in files:
            if file.endswith(('.py', '.js', '.sh', '.json', '.yml', '.yaml', '.cjs', '.mjs')):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        for pattern in SENSITIVE_PATTERNS:
                            if re.search(pattern, content, re.IGNORECASE):
                                print(f"[!] ALERTA SAST: Posible secreto expuesto en -> {file_path}")
                                findings += 1
                except Exception:
                    pass

    if findings == 0:
        print("[+] Resultado SAST: Cero credenciales reales o artefactos vulnerables detectados en el código fuente.")
        return True
    else:
        print(f"[!] Total de anomalías de seguridad reales detectadas: {findings}")
        return False

if __name__ == "__main__":
    success = scan_repository()
    sys.exit(0 if success else 1)
