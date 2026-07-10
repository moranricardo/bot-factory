import os, json, sys
from google import genai

api_key = os.environ.get('GEMINI_API_KEY')
if not api_key:
    print("Error: GEMINI_API_KEY no definida en el entorno.")
    sys.exit(1)

client = genai.Client(api_key=api_key)

try:
    with open('gerrit_data.json', 'r') as f:
        gerrit_data = json.load(f)
    
    contexto = json.dumps(gerrit_data[:2], indent=2)
    prompt = f'Analiza: {contexto}'

    print('--- [RA PULSE: ENVIANDO A GEMINI] ---')
    response = client.models.generate_content(
        model='gemini-2.0-flash',
        contents=prompt,
    )
    print('--- [RA PULSE RESPUESTA COGNITIVA] ---')
    print(response.text)

except Exception as e:
    print(f"Error durante la ejecución de la API: {e}")
    sys.exit(1)
