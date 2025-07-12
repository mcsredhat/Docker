# Use specific nginx version for better reproducibility
FROM nginx:1.18

# Adding metadata for the image
LABEL maintainer="farajassulai@gmail.com" \
    version="1.0" \
    description="NGINX web app with secure user" \
    app_name="nginx" \
    app-version="1.0.0" \
    app="frontend-webserver"

# Build arguments
ARG NGINX_VERSION=1.18
ARG USERNAME=webuser
ARG USERID=1001
ARG GROUPID=1001
ARG GROUPNAME=webgroup
ARG APP_PORT=8080

# Environment variables
ENV NGINX_HOST=localhost \
    NGINX_PORT=${APP_PORT} \
    NGINX_WORKER_PROCESSES=auto \
    NGINX_WORKER_CONNECTIONS=1024

# Install required packages and setup directories as root
RUN apt-get update && \
    apt-get install -y curl gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Create group and user
    groupadd -g ${GROUPID} ${GROUPNAME} && \
    useradd -m -u ${USERID} -s /bin/bash -g ${GROUPID} ${USERNAME} && \
    # Create application directories
    mkdir -p /app/src /app/logs /app/data /app/static && \
    # Create nginx directories that need to be writable by non-root user
    mkdir -p /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp \
    /var/run/nginx && \
    # Create a custom nginx.conf directory for non-root user
    mkdir -p /app/nginx/conf.d && \
    # Set ownership for nginx cache directories
    chown -R ${USERNAME}:${GROUPNAME} /var/cache/nginx && \
    chmod -R 755 /var/cache/nginx && \
    # Set ownership for nginx run directory
    chown -R ${USERNAME}:${GROUPNAME} /var/run/nginx && \
    chmod -R 755 /var/run/nginx && \
    # Set ownership for app directories
    chown -R ${USERID}:${GROUPID} /app && \
    chmod -R 755 /app && \
    # Set ownership for nginx config directory
    chown -R ${USERNAME}:${GROUPNAME} /app/nginx && \
    chmod -R 755 /app/nginx

# Set working directory
WORKDIR /app

# Copy application files with proper ownership
COPY --chown=${USERID}:${GROUPID} src/ ./src/
COPY --chown=${USERID}:${GROUPID} static/ ./static/

# Copy nginx configuration template and startup script
COPY --chown=${USERID}:${GROUPID} src/nginx.conf.template /app/nginx/server.conf.template
COPY --chown=${USERID}:${GROUPID} nginx.conf /app/nginx/nginx.conf
COPY --chown=${USERID}:${GROUPID} start-nginx.sh /app/start-nginx.sh

# Make startup script executable
RUN chmod +x /app/start-nginx.sh

# Create volume mount points
VOLUME ["/app/data", "/app/logs"]

# Expose the application port
EXPOSE ${APP_PORT}

# Switch to non-root user
USER ${USERNAME}

# Set shell options for better error handling
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${NGINX_PORT}/health || exit 1

# Signal for graceful shutdown
STOPSIGNAL SIGQUIT

# Default command to start nginx with template processing
CMD ["/app/start-nginx.sh"]