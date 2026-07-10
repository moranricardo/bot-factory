import os, json
import sys
from google import genai

# Verificar existencia de datos
if not os.path.exists('gerrit_data.json'):
    print("Error: gerrit_data.json no encontrado.")
    sys.exit(1)

client = genai.Client(api_key=os.environ['GEMINI_API_KEY'])
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
