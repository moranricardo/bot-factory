import subprocess

class AgenteCustomTools:
    def ejecutar(self, comando):
        try:
            return subprocess.check_output(comando, shell=True, text=True)
        except Exception as e:
            return f"Error al ejecutar comando: {e}"
