#!/bin/sh
set -e

# Function to handle graceful shutdown
graceful_shutdown() {
    echo "Received shutdown signal, gracefully shutting down..."
    if [ ! -z "$APP_PID" ]; then
        kill -TERM "$APP_PID" 2>/dev/null || true
        wait "$APP_PID" 2>/dev/null || true
    fi
    exit 0
}

# Trap signals for graceful shutdown
trap graceful_shutdown TERM INT

# Pre-flight checks
echo "Starting ${APP_NAME} v${APP_VERSION} in ${APP_ENV} mode..."

# Verify required directories exist
for dir in "${DATA_DIR}" "${LOGS_DIR}" "${CONFIG_DIR}"; do
    if [ ! -d "$dir" ]; then
        echo "Error: Required directory $dir does not exist"
        exit 1
    fi
done

# Health check before starting (if healthcheck script exists)
if [ -f "${APP_DIR}/bin/healthcheck" ]; then
    echo "Running pre-flight health check..."
    "${APP_DIR}/bin/healthcheck" || {
        echo "Pre-flight health check failed"
        exit 1
    }
fi

# Start the application
echo "Starting application..."
exec node dist/index.js &

APP_PID=$!
echo "Application started with PID: $APP_PID"

# Wait for the application process
wait "$APP_PID"