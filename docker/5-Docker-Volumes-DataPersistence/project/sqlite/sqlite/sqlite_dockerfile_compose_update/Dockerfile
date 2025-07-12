# Base image - Use standard Debian instead
FROM debian:bullseye-slim

# Build-time variables
ARG SQLITEVER=sqlite3
ARG USER_ID=1010
ARG USER_NAME=sqlituser
ARG GROUP_ID=1010
ARG GROUP_NAME=sqlitegroup
ARG APP_ENV=production
ARG BASH_SHELL=/bin/bash
ARG APP_DIR=/data
ARG MOUNT1=/data/datas
ARG MOUNT2=/data/logs
ARG db_file=/data/mydb.db

# Set runtime environment variables from ARGs
ENV SQLITE_VER=${SQLITEVER} \
    USER_ID=${USER_ID} \
    USER_NAME=${USER_NAME} \
    GROUP_ID=${GROUP_ID} \
    GROUP_NAME=${GROUP_NAME} \
    db_dir=${db_file} \
    APP_ENV=${APP_ENV} \
    BASH_SHELL=${BASH_SHELL} \
    APP_DIR=${APP_DIR} \
    MOUNT1=${MOUNT1} \
    MOUNT2=${MOUNT2} \
    BACKEND_HOST=database \
    TZ=GMT+2

# Labels
LABEL maintainer="farajassulai@gmail.com"
LABEL environment=${APP_ENV}
LABEL description="project sqlite3 database with non-root user"
LABEL date-created="2025-06-11"
LABEL version=${SQLITE_VER}

# Set working directory
WORKDIR ${APP_DIR}

# Install packages, create directories, user & group, set permissions
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sqlite3 \
    curl \
    bash && \
    mkdir -p ${APP_DIR} ${MOUNT1} ${MOUNT2} && \
    groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -m -u ${USER_ID} -g ${GROUP_NAME} -s /bin/bash ${USER_NAME} && \
    chown -R ${USER_ID}:${GROUP_ID} ${APP_DIR} ${MOUNT1} ${MOUNT2} && \
    chmod 755 ${APP_DIR} ${MOUNT1} ${MOUNT2} && \
    rm -rf /var/lib/apt/lists/*

# Copy only init.sql file
COPY --chown=${USER_ID}:${GROUP_ID} ./init.sql ${APP_DIR}/

# Create volume mount points
VOLUME ["${MOUNT1}", "${MOUNT2}"]

# Switch to non-root user
USER ${USER_NAME}

# STOPSIGNAL (docker stop --signal=SIGTERM "container_id")
STOPSIGNAL SIGTERM

# Healthcheck - SQLite database health check
HEALTHCHECK --interval=30s \
    --timeout=15s \
    --start-period=10s \
    --retries=3 \
    CMD test -s /data/mydb.db && sqlite3 /data/mydb.db "SELECT 1;" > /dev/null || exit 1

# Default command - Initialize database and keep container running
CMD ["/bin/bash", "-c", "if [ ! -s /data/mydb.db ]; then echo 'Initializing database...'; sqlite3 /data/mydb.db < /data/init.sql; echo 'Database initialized successfully!'; else echo 'Database already exists'; fi; echo 'SQLite container is ready. Database location: /data/mydb.db'; echo 'Container will stay running. Use docker exec to interact.'; tail -f /dev/null"]