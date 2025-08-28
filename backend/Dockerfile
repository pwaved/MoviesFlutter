# Usa a imagem base do Node.js
FROM node:18-alpine

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de dependências
COPY package.json package-lock.json ./

# Instala todas as dependências, incluindo as de desenvolvimento
RUN npm install

# Expõe a porta que a aplicação vai usar
EXPOSE 3000