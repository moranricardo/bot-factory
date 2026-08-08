import os
import json
import urllib.request
import urllib.error

def cargar_estado():
    ruta_state = os.path.join(os.path.dirname(__file__), '..', 'config', 'state.json')
    if os.path.exists(ruta_state):
        with open(ruta_state, 'r') as f:
            return json.load(f)
    return {}

def consultar_ra(prompt_contexto):
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        return "GEMINI_API_KEY no encontrada en las variables de entorno."

    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
    headers = {"Content-Type": "application/json"}
    payload = {
        "contents": [{
            "parts": [{"text": f"Eres el núcleo cognitivo de Ra Pulse. Analiza el estado y responde: {prompt_contexto}"}]
        }]
    }

    try:
        req = urllib.request.Request(url, data=json.dumps(payload).encode('utf-8'), headers=headers)
        with urllib.request.urlopen(req) as response:
            res = json.loads(response.read().decode('utf-8'))
            return res['candidates'][0]['content']['parts'][0]['text']
    except Exception as e:
        return f"Error en conexión HTTP: {e}"

if __name__ == "__main__":
    estado = cargar_estado()
    print("⚡ Puente cognitivo ultraligero inicializado.")
    print(f"📊 Estado cargado desde config/: {json.dumps(estado, indent=2)}")
