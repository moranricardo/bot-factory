import os
import subprocess

def find_git_repos(start_path):
    git_repos = []
    expanded_path = os.path.expanduser(start_path)
    for root, dirs, files in os.walk(expanded_path):
        # Ignorar directorios ocultos del sistema (ej. .cache, .termux, .git, etc., excepto al inicio)
        dirs[:] = [d for d in dirs if not d.startswith('.') or d == '.git']
        
        if '.git' in dirs:
            git_repos.append(root)
            # Detener la bajada recursiva dentro de este repositorio
            dirs.remove('.git')
            
        # Evitar carpetas pesadas de dependencias
        if 'node_modules' in dirs:
            dirs.remove('node_modules')
            
    return list(set(git_repos)) # Eliminar duplicados si los hubiera

def audit_all_repos():
    print("🌐 [Iniciando Auditoría Masiva Inteligente y Optimizada - POD v1.0] 🌐\n")
    
    repos = find_git_repos('~/')
    clean_count = 0
    dirty_count = 0

    for repo_path in sorted(repos):
        try:
            result = subprocess.run(
                ["git", "-C", repo_path, "status", "--porcelain"],
                capture_output=True,
                text=True,
                check=True
            )
            
            status_output = result.stdout.strip()
            if status_output:
                print(f"⚠️  [MODIFICADO/SUCIO] {repo_path}")
                for line in status_output.split('\n'):
                    print(f"     -> {line}")
                dirty_count += 1
            else:
                print(f"✅ [LIMPIO / SSoT Sincronizado] {repo_path}")
                clean_count += 1
        except Exception as e:
            print(f"❌ [ERROR DE ACCESO] {repo_path}: {e}")

    print(f"\n--- Resumen de Auditoría Optimizada ---")
    print(f"Repositorios únicos detectados: {len(repos)}")
    print(f"Repositorios limpios y seguros: {clean_count}")
    print(f"Repositorios con cambios pendientes/locales: {dirty_count}")

if __name__ == "__main__":
    audit_all_repos()
