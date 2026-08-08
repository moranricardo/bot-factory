import os
import json
import google.generativeai as genai

# Configuración del puente
if "GEMINI_API_KEY" in os.environ:
    genai.configure(api_key=os.environ["GEMINI_API_KEY"])

model = genai.GenerativeModel('gemini-1.5-pro')

def cargar_estado():
    ruta_state = os.path.join(os.path.dirname(__file__), '..', 'config', 'state.json')
    if os.path.exists(ruta_state):
        with open(ruta_state, 'r') as f:
            return json.load(f)
    return {}

def consultar_ra(prompt_contexto):
    response = model.generate_content(f"Eres el núcleo cognitivo de Ra Pulse. Analiza el siguiente estado del sistema y responde con una recomendación estructurada: {prompt_contexto}")
    return response.text

if __name__ == "__main__":
    estado = cargar_estado()
    print("Puente cognitivo inicializado.")
    print(f"Estado cargado desde config/: {estado}")
