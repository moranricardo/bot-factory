# =============================================================================
# Módulo: bot_auditor.py (bot-factory)
# Versión: 2.0 (Active Sentinel)
# Propósito: Evaluar cláusulas SSoT y autorizar flujos de trabajo
# =============================================================================
import pathlib
import sys

class BotAuditorSSoT:
    def __init__(self):
        self.registro_path = pathlib.Path.home() / "proyectos/snapshots/REGISTRO_MUTACIONES.log"
        self.huella_bot = "[🤖 Bot-Factory:Auditor-v2]"

    def validar_clausula(self):
        print("\n=======================================================")
        print(f"{self.huella_bot} Escaneando directivas en el SSoT central...")
        print("=======================================================\n")
        
        if not self.registro_path.exists():
            print(f"[!] Error: No se encuentra el registro blindado en {self.registro_path}")
            sys.exit(1)

        with open(self.registro_path, "r") as f:
            lineas = f.readlines()
            
            if not lineas:
                print(f"[!] El registro SSoT está vacío.")
                sys.exit(1)
                
            ultima_mutacion = lineas[-1].strip()
            
            # Evaluación simple basada en la estructura del log (evento | key | detalle)
            partes = ultima_mutacion.split(" | ")
            if len(partes) >= 4:
                evento = partes[1].strip()
                key = partes[2].strip()
                detalle = partes[3].strip()
                
                print(f"[*] Analizando transacción: {evento} sobre '{key}'")
                print(f"[*] Detalles criptográficos: {detalle}")
                
                # Simularemos la extracción de la cláusula basada en el evento EMULATE
                if evento == "EMULATE":
                     print(f"\n[🛡️ PROTOCOLO AUTORIZADO] Cláusula IRREVOCABLE validada.")
                     print(f"[✓] El bot está listo para accionar basándose en la versión asegurada.")
                elif "DESTRUCTIVO" in ultima_mutacion:
                     print(f"\n[❌ ALERTA NIVEL 1] Detectada transacción bloqueada por cláusula DESTRUCTIVA.")
                     print(f"[!] Deteniendo orquestación.")
                else:
                     print(f"\n[?] Estado ambiguo. Se requiere revisión manual.")
                     
            else:
                print(f"[!] Formato de registro no reconocido.")

if __name__ == "__main__":
    agente = BotAuditorSSoT()
    agente.validar_clausula()
