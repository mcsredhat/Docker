FROM node:18-slim

# Add metadata
LABEL maintainer="Docker Training"
LABEL version="1.0"
LABEL environment="development"

# Create app directory
WORKDIR /app

# Install app dependencies
COPY app/server.js .

# Set restart policy for crashed containers
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Expose port
EXPOSE 3000

# Run application
CMD ["node", "server.js"]
