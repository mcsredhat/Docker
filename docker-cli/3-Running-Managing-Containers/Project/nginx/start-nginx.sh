#!/bin/bash
set -e

# Function to substitute environment variables in template
envsubst_template() {
    local template_file="$1"
    local output_file="$2"
    
    # Use envsubst to replace environment variables
    envsubst < "$template_file" > "$output_file"
}

# Process the nginx server configuration template
echo "Processing nginx configuration template..."
envsubst_template "/app/nginx/server.conf.template" "/app/nginx/server.conf"

# Validate the nginx configuration
echo "Validating nginx configuration..."
nginx -t -c /app/nginx/nginx.conf

# Start nginx
echo "Starting nginx..."
exec nginx -c /app/nginx/nginx.conf -g "daemon off;"