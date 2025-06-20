FROM php:8.1-apache

# ARG variables
ARG PHPVER=8.1-apache
ARG USER_ID=1100
ARG USER_NAME=phpapacheuser
ARG GROUP_ID=1100
ARG GROUP_NAME=phpapachegrp
ARG DIR_PATH=/var/www/html/
ARG APP_PORT=8080
ARG MOUNT1=/php/data
ARG MOUNT2=/php/logs
ARG SHELL=/bin/bash
ARG hostname=php-apache-host
ARG PHP_ENV=production
ARG HEALTH_URL="curl -f http://localhost:8080"
ARG VAR_RUN_PATH=/var/run/apache2
ARG CP_PHP_SRC=/php-apache/src
ARG CP_PHP_CFG=/php-apache/php-config
ARG CP_APACHE_CFG=/php-apache/apache-config
ARG VAR_LOGS=/var/log/apache2

# Create ENV variables
ENV USER_NAME=${USER_NAME} \
    USER_ID=${USER_ID} \
    GROUP_ID=${GROUP_ID} \
    GROUP_NAME=${GROUP_NAME} \
    DIR_PATH=${DIR_PATH} \
    APP_PORT=${APP_PORT} \
    MOUNT1_PATH=${MOUNT1} \
    MOUNT2_PATH=${MOUNT2} \
    SHELL_PATH=${SHELL} \
    HOSTNAME=${hostname} \
    HEALTH_URL=${HEALTH_URL} \
    VAR_RUN=${VAR_RUN_PATH} \
    VAR_LOGS=${VAR_LOGS}

# Labels
LABEL name="my_php_apache" \
    hostname="${hostname}" \
    app="backend" \
    tier="application" \
    environment="${PHP_ENV}" \
    maintainer="farajassulai@gmail.com" \
    description="php-apache2 application with custom configuration" \
    date-created="2025-06-20" \
    version="${PHPVER}"

# Working directory
WORKDIR ${DIR_PATH}

# Update packages, install dependencies, create directories and user
RUN apt-get update && \
    apt-get install -y curl vim && \
    docker-php-ext-install pdo_mysql && \
    mkdir -p ${VAR_RUN} ${DIR_PATH} ${MOUNT1_PATH} ${MOUNT2_PATH} ${VAR_LOGS} && \
    touch ${VAR_LOGS}/php_errors.log && \
    groupadd -g ${GROUP_ID} ${GROUP_NAME} && \
    useradd -u ${USER_ID} -M -g ${GROUP_NAME} -s ${SHELL_PATH} ${USER_NAME} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY ${CP_APACHE_CFG}/ports.conf /etc/apache2/ports.conf
COPY ${CP_APACHE_CFG}/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ${CP_PHP_CFG}/php.ini /usr/local/etc/php/php.ini

# Copy application source files
COPY ${CP_PHP_SRC}/index.php ${DIR_PATH}/

# Set proper ownership and permissions
RUN chown -R ${USER_NAME}:${GROUP_NAME} ${DIR_PATH} ${MOUNT1_PATH} ${MOUNT2_PATH} && \
    chmod -R 755 ${DIR_PATH} && \
    chmod 755 ${MOUNT1_PATH} ${MOUNT2_PATH} && \
    chmod 644 /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf && \
    chmod 644 /usr/local/etc/php/php.ini && \
    chown -R www-data:www-data ${VAR_LOGS}

# Enable Apache modules
RUN a2enmod rewrite headers expires deflate

# Enable the default site
RUN a2ensite 000-default

# Create mount points
VOLUME ["${MOUNT1_PATH}", "${MOUNT2_PATH}"]

# Set shell
SHELL ["${SHELL_PATH}", "-o", "pipefail", "-c"]

# Health check
HEALTHCHECK --interval=30s \
    --timeout=15s \
    --start-period=60s \
    --retries=5 \
    CMD curl -f http://localhost:8080 || exit 1

# Expose port
EXPOSE 8080

# Create log directory and set permissions
# RUN mkdir -p /var/log/apache2 && \
#     touch /var/log/apache2/php_errors.log && \
#     chown -R www-data:www-data /var/log/apache2

# Run command (Apache runs as root initially, then drops privileges)
CMD ["apache2-foreground"]