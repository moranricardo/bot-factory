import subprocess
import time
import sys

TARGET_CODESPACE = "potential-guacamole-6994qj4545j4f5gw5"
INTERVAL_SECONDS = 600  # 10 minutos (GitHub apaga a los 30 min por defecto)

print(f"[Guardián 24/7] Iniciando vigilancia sobre {TARGET_CODESPACE}...")

try:
    while True:
        timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
        # Mandamos un comando ultra ligero (un simple 'echo') para registrar actividad
        comando = f'gh codespace ssh -c {TARGET_CODESPACE} -- "echo pulsito"'
        
        try:
            subprocess.check_output(comando, shell=True, text=True, stderr=subprocess.STDOUT)
            print(f"[{timestamp}] Pulse enviado con éxito. Codespace estimulado y despierto.")
        except subprocess.CalledProcessError as e:
            print(f"[{timestamp}] ¡Alerta! Fallo al pulsar el Codespace: {e.output.strip()}", file=sys.stderr)
        
        time.sleep(INTERVAL_SECONDS)

except KeyboardInterrupt:
    print("\n[Guardián 24/7] Vigilancia desactivada por el usuario.")
