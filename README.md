# ⚡ Bot Factory — Ra Pulse Core

Sistema de automatización y puente cognitivo optimizado para Termux.

## 📐 Arquitectura del Monorepo

- config/: Configuración central (state.json)
- core/: Núcleo operativo y puente cognitivo (bridge.py, memory.py, health.py)
- knowledge/: Base conceptual y axiomas
- knowledge_graph/: Manifests e integridad del sistema
- modules/: Módulos JS ligeros (scraping.js)
- src/: Agentes especializados (bot_auditor.py)
- labs/: Laboratorio de pruebas
- guardian.py: Daemon de supervisión
- agente_custom.py: Ejecutor de comandos
- index.js: Entrada principal Node.js

## 📜 Axiomas Fundamentales
1. AXIOMA_01: El orden precede al conocimiento.
2. AXIOMA_02: La validación (Maat) es la única defensa contra el caos.
3. AXIOMA_03: El sistema debe ser capaz de auditar su propia estructura.

## 🚀 Inicio Rápido
- Node.js: `node index.js`
- Python: `python core/bridge.py`
