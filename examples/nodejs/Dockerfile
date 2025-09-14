# Multi-stage Node.js Dockerfile
FROM node:20-alpine as base

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create app directory
RUN mkdir -p /home/node/app && chown node:node /home/node/app
WORKDIR /home/node/app

# Switch to node user
USER node

# Development stage
FROM base as development

# Copy package files
COPY --chown=node:node package*.json ./

# Install all dependencies
RUN npm ci

# Copy source code
COPY --chown=node:node . .

EXPOSE 3000

CMD ["dumb-init", "npm", "run", "dev"]

# Build stage
FROM base as build

# Copy package files
COPY --chown=node:node package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY --chown=node:node . .

# Build the application
RUN npm run build

# Remove dev dependencies
RUN npm prune --production && npm cache clean --force

# Production stage
FROM base as production

# Copy package files and built application
COPY --chown=node:node package*.json ./
COPY --from=build --chown=node:node /home/node/app/node_modules ./node_modules
COPY --from=build --chown=node:node /home/node/app/dist ./dist

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["dumb-init", "node", "dist/index.js"]