#!/bin/sh
echo "Connecting to running container..."
docker exec -it $(docker ps -q --filter "name=app") sh
