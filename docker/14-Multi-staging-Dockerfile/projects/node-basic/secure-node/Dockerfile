# Build stage
FROM node:18-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install && \
    ls -la && \
    mkdir -p node_modules && \
    ls -la node_modules

# Runtime stage
FROM node:18-slim
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 nodegroup && \
    useradd -u 1001 -g nodegroup -m nodeuser

WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --chown=nodeuser:nodegroup . .

USER nodeuser
EXPOSE 3000
CMD ["node", "app.js"]
