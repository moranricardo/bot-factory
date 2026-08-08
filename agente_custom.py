import subprocess

class AgenteCustomTools:
    def __init__(self):
        self.nombre = "Agente-CustomTools"

    def ejecutar(self, comando):
        print(f"--- [Ra Pulse] {self.nombre} ejecutando: {comando} ---")
        try:
            res = subprocess.run(
                comando,
                shell=True,
                capture_output=True,
                text=True
            )
            if res.returncode == 0:
                return res.stdout
            return res.stderr
        except Exception as e:
            return f"Error: Fallo en ejecución: {e}"
