# -------- 1. Build React Frontend --------
FROM node:18-alpine as frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ .
RUN npm run build


# -------- 2. Build Backend (with Frontend) --------
FROM node:18-alpine

WORKDIR /app

# Backend dependencies
COPY backend/package*.json ./
RUN npm install

# Copy backend source
COPY backend/ .

# Copy built frontend into backend's public directory
COPY --from=frontend-builder /app/frontend/build ./public

EXPOSE 5000

CMD ["node", "server.js"]
