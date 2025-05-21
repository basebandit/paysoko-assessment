# Build stage
FROM node:18-alpine AS build

WORKDIR /usr/src/app

# Copy package files and install only production dependencies
COPY package*.json ./
RUN npm ci --only=production

# Run stage
FROM node:18-alpine

# Create app directory and non-root user
WORKDIR /usr/src/app
RUN addgroup -g 1001 nodejs && \
    adduser -S -u 1001 -G nodejs nodeuser

# Copy only necessary files from build stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=nodeuser:nodejs src ./src

# Set environment variables
ENV NODE_ENV=production \
    PORT=3000

# Expose API port
EXPOSE 3000

# Switch to non-root user
USER nodeuser

# Use CMD instead of ENTRYPOINT for more flexibility in Kubernetes
CMD ["node", "src/index.js"]