# Stage 1: Build React Frontend
FROM node:22-alpine AS frontend-builder
WORKDIR /app

# Install dependencies
COPY sapa-frontend/package*.json ./
RUN npm install

# Build application
COPY sapa-frontend/ ./
RUN npm run build

# Stage 2: Production Nginx Server
FROM nginx:alpine

# Copy built frontend
COPY --from=frontend-builder /app/dist /var/www/frontend

# Copy Laravel public directory (for static assets & blade maps)
COPY sapa-laravel/public /var/www/laravel/public

# Copy Nginx configuration
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 8000

CMD ["nginx", "-g", "daemon off;"]
