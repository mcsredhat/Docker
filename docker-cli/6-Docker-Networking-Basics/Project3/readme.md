# Web Application with Networking and User Uploads

This project demonstrates how to deploy a web application with persistent storage for user uploads and networking for communication between services.

## Overview

The setup uses Docker and Docker Compose to create a containerized web application based on Nginx. Data persistence for user uploads is achieved through Docker volumes, ensuring user-uploaded content survives container restarts or upgrades.

## Directory Structure

```
webapp/
│── Dockerfile
│── docker-compose.yml
```

## Features

- **Persistent Storage**: User uploads are stored in a Docker volume that persists across container restarts and upgrades
- **Network Connectivity**: The application is accessible via port 8080 on the host machine
- **Isolated Environment**: Container runs in its own network for improved security

## Setup Instructions

1. **Create and Start the Web Application**

   ```
   docker compose up -d
   ```

   This command builds the Docker image and starts the container in detached mode.

## Accessing the Application

The web application is accessible at:
```
 http://localhost:8080
```

## Maintaining the Application

### Upgrading Without Losing Data

One of the benefits of this architecture is the ability to upgrade the application without losing user data:
1. Stop and remove the current container
```
docker compose down
```
2. Pull the latest Nginx image to update the application
```
docker pull nginx:latest
```
3. Rebuild and restart the container
```
docker compose up -d
```


Since user uploads are stored in a persistent volume, all data remains intact during this process.

## Working with User Uploads

### Access Upload Directory

To access the uploads directory from within the container:

```
docker exec -it my-webapp bash
```

```
cd /app/uploads
```

### Adding Test Files

To test the persistence of the uploads volume:

```
docker exec -it my-webapp bash -c "echo 'test content' > /app/uploads/testfile.txt"
```

### Verifying Persistence

After restarting the container, check if your test file still exists:

```
docker compose down
```

```
docker compose up -d
```

```
docker exec -it my-webapp cat /app/uploads/testfile.txt
```

## Troubleshooting

- **Port conflicts**: If port 8080 is already in use on your host machine, modify the port mapping in the docker-compose.yml file.
- **Volume mounting issues**: Ensure that the volume paths are correctly specified.
- **Networking problems**: Check if the container is running in the correct network.
- **Permission issues**: You may need to adjust file permissions for the uploads directory.

