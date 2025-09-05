# Multi-stage build for Vue.js app

# Build stage
FROM node:18-alpine as build-stage

# Set working directory
WORKDIR /app

# Copy package files first (better cache for dependencies)
COPY package*.json ./

# Install all dependencies (including dev, needed for build)
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the app
RUN npm run build

# Production stage
FROM nginx:stable-alpine as production-stage

# Copy built app from build stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Optional: copy a custom nginx config
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
