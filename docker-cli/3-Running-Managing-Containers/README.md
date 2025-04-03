# Running and Managing Docker Containers

A comprehensive guide to effectively deploy, control, and monitor containerized applications in development and production environments.

## Overview

This project provides practical guidance on Docker container lifecycle management, covering essential commands and best practices for working with Docker containers in various environments.

## Table of Contents

1. [Running Containers](#1-running-containers)
2. [Detached Mode (Background Containers)](#2-detached-mode-background-containers)
3. [Monitoring and Management](#3-monitoring-and-management)
4. [Advanced Container Configuration](#4-advanced-container-configuration)
5. [Networking](#5-networking)
6. [Data Persistence](#6-data-persistence)
7. [Resource Management](#7-resource-management)


## 1. Running Containers

The `docker run` command is fundamental to Docker operations. When executed, it performs multiple steps:

1. Checks for the image locally
2. Downloads the image from a registry if not found
3. Creates a new container filesystem based on the image
4. Allocates a network interface and IP address
5. Sets up environment variables from the image
6. Executes the specified command (or default entrypoint)

### Basic Usage

```
docker run ubuntu:20.04 echo "Hello, Docker!"
```

This command creates an isolated environment, mounts the Ubuntu 20.04 filesystem layers in read-only mode, adds a writable layer on top, and executes your command.

### Common Options


# Name your container for easier reference
```
docker run --name webapp-test nginx:latest
```
# Set environment variables
```
docker run -e DB_HOST=mysql -e DB_PORT=3306 my-app:latest
```

# Mount volumes for data persistence
```
docker run -v $(pwd)/data:/app/data my-app:latest
```
# Set resource limits
```
docker run --memory=512m --cpus=0.5 nginx:latest
```

### Container Persistence

When a container exits, its filesystem changes remain intact until you remove it. This lets you:

# After a container exits
```
docker cp exited-container:/app/logs ./logs
```
```
docker restart exited-container
```

## 2. Detached Mode (Background Containers)
Detached mode is essential for service-oriented applications. When you use the `-d` flag, Docker:
1. Starts the container in the background
2. Redirects container output to the Docker daemon
3. Returns control immediately to your terminal
4. Provides an ID for future reference

```
docker run -d --name api-service -p 8080:80 my-api:latest
```
This is ideal for web servers, databases, and other long-running services.

## 3. Monitoring and Management

### Monitoring Detached Containers
# Stream logs in real-time (like tail -f)
```
docker logs -f api-service
```
# Show container resource usage
```
docker stats api-service
```
# Show detailed configuration
```
docker inspect api-service
```

## 4. Advanced Container Configuration

Real-world usage often involves multiple related containers with complex configurations:
# Run a web application with a connected database (legacy linking)
```
docker run -d --name mysql-db -e MYSQL_ROOT_PASSWORD=secret mysql:8.0
```
```
docker run -d --name web-app --link mysql-db -p 80:80 my-webapp:latest
```

## 5. Networking

Modern Docker applications typically use custom networks for container communication:

# Create a custom network
```
docker network create my-network
```
# Run containers on the custom network
```
docker run -d --name mysql-db --network my-network mysql:8.0
```
```
docker run -d --name web-app --network my-network -p 80:80 my-webapp:latest
```

## 6. Data Persistence

Configure host directories for persistent data:
# Create directories for persistent data
```
sudo mkdir -p /host/nginx
```
```
sudo touch /host/nginx/nginx.conf
```
```
sudo chmod 644 /host/nginx/nginx.conf
```

## 7. Resource Management

### Database Container Advvanced Example

```
docker run --name my-database \
  --env MYSQL_ROOT_PASSWORD=root \
  --env MYSQL_DATABASE=mydb \
  --env MYSQL_USER=myuser \
  --env MYSQL_PASSWORD=mypassword \
  --hostname mysql-host \
  --label app=database \
  --memory=512m \
  --cpus="1.5" \
  --network my-network \
  --publish 3306:3306 \
  --volume mysql_data:/var/lib/mysql \
  --user 1000:1000 \
  --workdir /var/lib/mysql \
  --detach \
  mysql:latest
```

This command:
- Assigns a custom name to the container
- Sets environment variables for database configuration
- Configures an internal hostname
- Adds labels for container categorization
- Limits memory and CPU resources
- Connects to a custom network
- Maps container port to host
- Mounts a volume for data persistence
- Runs as a specific user
- Sets the working directory
- Runs in detached mode
- Uses the latest MySQL image

### Web Server Container Advanced Example

```
docker run --name my-nginx \
  --env BACKEND_HOST=my-database \
  --hostname nginx-host \
  --label app=webserver \
  --memory=256m \
  --cpus="0.8" \
  --network my-network \
  --publish 8080:80 \
  --volume /host/nginx/conf:/etc/nginx/conf.d \
  --user 1000:1000 \
  --workdir /etc/nginx \
  --detach \
  nginx:latest
```

This command configures an Nginx web server with:
- A custom container name for easy reference
- Environment variable for backend connectivity
- Custom internal hostname
- Categorization label
- Memory limit of 256MB
- CPU limit of 0.8 cores
- Connection to the same network as the database
- Port mapping from container port 80 to host port 8080
- Volume mounting for Nginx configuration
- Specific user permissions
- Custom working directory
- Detached mode operation
- Latest Nginx image

