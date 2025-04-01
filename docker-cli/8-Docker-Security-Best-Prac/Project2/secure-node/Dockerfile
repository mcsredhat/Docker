FROM node:18-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install

# Runtime stage
FROM node:18-slim

# Update and clean
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -g 1001 nodegroup && \
    useradd -u 1001 -g nodegroup -m nodeuser

# Set up app directory with proper permissions
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --chown=nodeuser:nodegroup . .

# Switch to non-root user
USER nodeuser

# Expose port and run application
EXPOSE 3000
CMD ["node", "app.js"]
