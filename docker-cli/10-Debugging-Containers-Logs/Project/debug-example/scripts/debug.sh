#!/bin/bash
# Debug script for troubleshooting build issues

echo "Attempting to build problematic Dockerfile..."
docker build -f Dockerfile.bad -t debug-example:bad .

echo -e "\nLast successful layer ID will be shown in error message above"
echo "Enter the layer ID to debug (e.g., abc123def456):"
read layer_id

if [ ! -z "$layer_id" ]; then
    echo "Launching interactive shell in last successful layer..."
    docker run -it "$layer_id" /bin/bash
else
    echo "No layer ID provided, skipping interactive debug"
fi

echo -e "\nBuilding fixed version..."
docker build --no-cache -f Dockerfile.fixed -t debug-example:fixed .