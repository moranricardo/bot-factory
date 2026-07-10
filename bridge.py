import os
import json
import sys
from openai import AzureOpenAI

endpoint = os.environ.get('AZURE_OPENAI_ENDPOINT')
api_key = os.environ.get('AZURE_OPENAI_API_KEY')
deployment = os.environ.get('AZURE_OPENAI_DEPLOYMENT')

if not all([endpoint, api_key, deployment]):
    print('Error: Variables de Azure no configuradas.')
    sys.exit(1)

client = AzureOpenAI(azure_endpoint=endpoint, api_key=api_key, api_version='2024-05-01-preview')

try:
    with open('gerrit_data.json', 'r') as f:
        data = json.load(f)
    response = client.chat.completions.create(
        model=deployment,
        messages=[{'role': 'user', 'content': f'Analiza: {json.dumps(data[:2])}'}]
    )
    print('--- [RA PULSE: RESPUESTA AZURE] ---')
    print(response.choices[0].message.content)
except Exception as e:
    print(f'Error en Azure: {e}')
    sys.exit(1)
