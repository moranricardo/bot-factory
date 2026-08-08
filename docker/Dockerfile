FROM node:20-slim

# Instalar Python 3 y herramientas básicas
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar archivos de dependencias e instalar
COPY package*.json ./
RUN npm ci --only=production

# Copiar el resto del código
COPY . .

# Comando por defecto para iniciar el orquestador
CMD ["npm", "start"]
