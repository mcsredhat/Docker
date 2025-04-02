#!/bin/bash
# Container inspection script

CONTAINER_NAME="debug-container"

echo "Starting container..."
docker run -d --name "$CONTAINER_NAME" debug-example:fixed

echo -e "\nBasic container info:"
docker inspect "$CONTAINER_NAME" | head -n 20

echo -e "\nSpecific information using format templates:"
echo "Exit Code and Error:"
docker inspect --format '{{.State.ExitCode}} {{.State.Error}}' "$CONTAINER_NAME"
echo "IP Address:"
docker inspect --format '{{.NetworkSettings.IPAddress}}' "$CONTAINER_NAME"
echo "Environment Variables:"
docker inspect --format '{{range .Config.Env}}{{.}}{{println}}{{end}}' "$CONTAINER_NAME"
echo "Mounted Volumes:"
docker inspect --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}' "$CONTAINER_NAME"

echo -e "\nCleaning up..."
docker stop "$CONTAINER_NAME"
docker rm "$CONTAINER_NAME"