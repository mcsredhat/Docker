FROM mysql:8.0

# Build-time variables
ARG SQLVER=8.0
ARG USER_ID=1010
ARG USER_NAME=sqluser
ARG GROUP_ID=1010
ARG GROUP_NAME=sqlgroup
ARG APP_PORT=3306
ARG APP_ENV=production
ARG BASH_SHELL=/bin/bash
ARG APP_DIR=/sqldb
ARG MOUNT1=/sqldb/data
ARG MOUNT2=/sqldb/logs
ARG MYSQL_DATABASE=wordpress
ARG MYSQL_USER=sqluser
ARG MYSQL_PASSWORD=wppassword
ARG MYSQL_ROOT_PASSWORD=rootpass

# Set environment variables
ENV SQLVER=${SQLVER} \
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
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    MYSQL_DATABASE=${MYSQL_DATABASE} \
    MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    MYSQL_USER=${MYSQL_USER} \
    TZ=Europe/Paris

# Labels
LABEL maintainer="farajassulai@gmail.com"
LABEL environment=${APP_ENV}
LABEL description="MySQL database server with custom configuration"
LABEL date-created="2025-06-17"
LABEL version=${SQLVER}

# Create custom user and group (but don't switch to it for MySQL)
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -u ${USER_ID} -g ${GROUP_NAME} -m -s ${BASH_SHELL} ${USER_NAME}

# Create custom directories for potential future use
RUN mkdir -p ${APP_DIR} ${MOUNT1} ${MOUNT2} && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR}

# Copy MySQL configuration files
COPY ./config/my.cnf /etc/mysql/conf.d/custom.cnf
COPY ./config/init.sql /docker-entrypoint-initdb.d/

# Set proper permissions for config files
RUN chown ${USER_NAME}:${GROUP_NAME} /etc/mysql/conf.d/custom.cnf && \
    chmod 644 /etc/mysql/conf.d/custom.cnf && \
    chown ${USER_NAME}:${GROUP_NAME} /docker-entrypoint-initdb.d/init.sql && \
    chmod 644 /docker-entrypoint-initdb.d/init.sql


# Expose port
EXPOSE ${APP_PORT}

# Health check
HEALTHCHECK --interval=30s \
    --timeout=15s \
    --start-period=60s \
    --retries=5 \
    CMD mysqladmin ping -h localhost -u root -p${MYSQL_ROOT_PASSWORD} || exit 1

# Use default MySQL entrypoint (runs as root, which is required)
CMD ["mysqld"]