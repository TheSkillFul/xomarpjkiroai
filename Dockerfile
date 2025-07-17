# Multi-stage build for production
FROM node:18-alpine AS frontend-build

# Set working directory for frontend
WORKDIR /app/frontend

# Copy frontend package files
COPY frontend/package*.json ./
RUN npm ci --only=production

# Copy frontend source
COPY frontend/ ./
RUN npm run build

# Backend stage
FROM node:18-alpine AS backend-build

# Set working directory for backend
WORKDIR /app/backend

# Copy backend package files
COPY backend/package*.json ./
RUN npm ci --only=production

# Copy backend source
COPY backend/ ./

# Final production stage
FROM node:18-alpine AS production

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create app directory
WORKDIR /app

# Copy backend from build stage
COPY --from=backend-build /app/backend ./backend

# Copy frontend build from build stage
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S accountpro -u 1001

# Change ownership
RUN chown -R accountpro:nodejs /app
USER accountpro

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node backend/healthcheck.js

# Start the application
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "backend/server.js"]