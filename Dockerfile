# Étape 1 : compiler l'interface Vue
FROM node:22-alpine AS frontend-build

WORKDIR /app/maison-interface

COPY maison-interface/package*.json ./
RUN npm ci

COPY maison-interface/ ./
RUN npm run build

# Étape 2 : préparer le backend
FROM node:22-alpine AS backend

WORKDIR /app

COPY maison-serveur/package*.json ./
RUN npm ci --omit=dev

COPY maison-serveur/server.js ./

# Copier l'interface compilée dans le dossier servi par Express
COPY --from=frontend-build /app/maison-interface/dist ./public

ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

CMD ["node", "server.js"]