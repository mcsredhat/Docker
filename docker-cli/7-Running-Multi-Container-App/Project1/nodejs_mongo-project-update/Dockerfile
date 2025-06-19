FROM node:18-slim

# Build-time variables
ARG NODEVER=18.0
ARG USER_ID=1010
ARG USER_NAME=nodeuser
ARG GROUP_ID=1010
ARG GROUP_NAME=nodegroup
ARG APP_PORT=3000
ARG APP_ENV=production
ARG BASH_SHELL=/bin/bash
ARG APP_DIR=/node
ARG MOUNT1=/node/data
ARG MOUNT2=/node/logs

# Set environment variables
ENV NODEVER=${NODEVER} \
    USER_ID=${USER_ID} \
    USER_NAME=${USER_NAME} \
    GROUP_ID=${GROUP_ID} \
    GROUP_NAME=${GROUP_NAME} \
    APP_PORT=${APP_PORT} \
    APP_ENV=${APP_ENV} \
    BASH_SHELL=${BASH_SHELL} \
    APP_DIR=${APP_DIR} \
    MOUNT1=${MOUNT1} \
    MOUNT2=${MOUNT2} \
    TZ=Europe/Paris

# Labels
LABEL maintainer="farajassulai@gmail.com"
LABEL environment=${APP_ENV}
LABEL description="Node.js application server with custom configuration"
LABEL date-created="2025-06-17"
LABEL version=${NODEVER}

# Create working directory
WORKDIR ${APP_DIR}

# Install updates & packages, create user and group, create directories, set permissions
RUN apt-get update && \
    apt-get install -y curl && \
    mkdir -p ${APP_DIR} ${MOUNT1} ${MOUNT2} /app/tmp /app/var /tmp/run && \
    groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -u ${USER_ID} -m -d ${APP_DIR} -s ${BASH_SHELL} -g ${GROUP_NAME} ${USER_NAME} && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR} ${MOUNT1} ${MOUNT2} && \
    chmod 755 ${APP_DIR} ${MOUNT1} ${MOUNT2} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy application files
COPY ./app.js ${APP_DIR}/
COPY ./package*.json ${APP_DIR}/

# Install Node.js dependencies
RUN npm install --production

# Set proper permissions for application files
RUN chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR} && \
    chmod -R 755 ${APP_DIR}

# Switch to non-root user
USER ${USER_NAME}

# Expose port
EXPOSE ${APP_PORT}

# Add the mount point volumes
VOLUME ["${MOUNT1}", "${MOUNT2}"]

# Identify the shell to be used in image
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Health check
HEALTHCHECK --interval=30s \
    --timeout=15s \
    --start-period=60s \
    --retries=5 \
    CMD curl -f http://localhost:${APP_PORT}/health || exit 1

# Start the Node.js application
CMD ["node", "app.js"]