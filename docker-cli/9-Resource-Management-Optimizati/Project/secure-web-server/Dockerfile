# Use slim Python 3.9 as base image for smaller footprint
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PORT=8000

# Update packages and install security updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user and group for security
RUN groupadd -r appgroup && \
    useradd -r -g appgroup -m appuser

# Set working directory
WORKDIR /app

# Copy requirements first (optimization for caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Set ownership and permissions
RUN chown -R appuser:appgroup /app
USER appuser

# Expose port
EXPOSE ${PORT}

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:${PORT}/ || exit 1

# Run with gunicorn for production
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT} --workers 2 app:application"]
