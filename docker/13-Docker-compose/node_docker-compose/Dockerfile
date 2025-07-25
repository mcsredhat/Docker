# Create images (docker pull node:18-slim)
FROM node:18-slim

# Add metadata images (docker build --label maintainer="farajassulai@gmail.com" .)
LABEL maintainer="farajassulai@gmail.com" \
    version="1.0" \
    APP_name="node_java" \
    APP_VER="1.0.0" \
    description="create node java app with non_root user"

# Create the arguments variables (docker build --build-arg username="nodeuser" .)
ARG NODEVERSION=18
ARG USERNAME=nodeuser
ARG USERID=1010
ARG GROUPNAME=nodegroup
ARG GROUPID=1010
ARG APP_PORT=3000
ARG SHELL=/bin/bash
ARG APP_HOST=localhost

# Create environment variables (docker run -d --env port=${APP_PORT} "image_id")
ENV NODE_VERSION=${NODEVERSION} \
    USERNAME=${USERNAME} \
    USERID=${USERID} \
    GROUPNAME=${GROUPNAME} \
    GROUPID=${GROUPID} \
    APP_PORT=${APP_PORT} \
    SHELL=${SHELL} \
    APP_HOST=${APP_HOST} \
    NODE_ENV=production

# Create workingdir on the node image (docker run -w /app "image-id")
WORKDIR /app 

# Copy the source project code (docker cp ./app /app)
COPY ./app /app

# Install dependencies first (before switching to non-root user)
RUN npm install --omit=dev

# Install and update the packages, create directories&user,group,chown,chmod
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g ${GROUPID} ${GROUPNAME} && \
    useradd -m -u ${USERID} -g ${GROUPID} -s ${SHELL} ${USERNAME} && \
    mkdir -p /app/data /app/logs && \
    chown -R ${USERNAME}:${GROUPNAME} /app /app/data /app/logs && \
    chmod 755 /app

# Add the mount point volume (docker run -d --volume /app/data "image-id")
VOLUME ["/app/data", "/app/logs"]

# Switch to non-root user
USER ${USERNAME}

# Port (docker run --publish 3000:3000 "image-id")
EXPOSE ${APP_PORT}

# Healthcheck (docker run --healthcheck health-cmd "curl -f http://localhost:3000/health || exit 1")
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://${APP_HOST}:${APP_PORT}/health || exit 1

# STOPSIGNAL (docker stop --signal=SIGTERM "container_id")
STOPSIGNAL SIGTERM

# CMD (docker exec -it "container-id" /bin/bash -c "node server.js")
CMD ["node", "server.js"]