# Docker Management Guide

This repository contains documentation and examples for efficiently managing Docker containers and volumes in development and production environments.

## Table of Contents

- [Container Management](#container-management)
  - [Understanding Container Visibility](#understanding-container-visibility-docker-ps)
  - [Working with Container Logs](#deep-dive-into-container-logs-docker-logs)
  - [Container Inspection and Troubleshooting](#container-inspection-and-troubleshooting-docker-inspect)
  - [Process Monitoring](#process-monitoring-within-containers-docker-top)
  - [Container Cleanup](#efficient-container-removal-and-cleanup-docker-rm)
- [Docker Volumes & Data Persistence](#docker-volumes--data-persistence)
  - [Creating Volumes](#1-creating-a-volume-docker-volume-create)
  - [Mounting Volumes](#2-mounting-volumes-in-containers-docker-run--v)
  - [Inspecting Volumes](#3-inspecting-and-managing-volumes-docker-volume-inspect)
  - [Removing Volumes](#4-removing-volumes-docker-volume-rm)
  - [Troubleshooting Volumes](#5-troubleshooting-docker-volumes)
  - [Volume Drivers](#6-understanding-volume-drivers)
  - [Volume Security](#7-volume-security-best-practices)

## Container Management

### Understanding Container Visibility (docker ps)

The `docker ps` command provides critical operational information about your containers:

# Show all containers, including stopped ones
```
docker ps -a
```
# Show only running containers with specific labels
```
docker ps --filter "label=environment=production" --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
```
# Find containers consuming the most resources
```
docker ps --format "{{.ID}}: {{.Names}}" | xargs docker stats --no-stream
```
# List all containers that exited with an error code
```
docker ps -a --filter "status=exited" --filter "exited=1"
```

### Deep Dive into Container Logs (docker logs)

Understand and manage container logs effectively:

# View logs with timestamps for debugging timing issues
```
docker logs --timestamps web-server
```
# Extract recent error logs for troubleshooting
```
docker logs --since 30m api-service | grep -i error > recent_errors.log
```
# Monitor multiple containers simultaneously
```
docker logs -f $(docker ps -q --filter name=api-) 2>&1 | grep "Connection refused"
```

#### Log Management for Production
# Run with log driver configuration
```
docker run -d --log-driver=syslog --log-opt syslog-address=udp://logserver:514 nginx
```
# Configure log rotation to prevent disk space issues
```
docker run -d --log-opt max-size=10m --log-opt max-file=3 nginx
```

### Container Inspection and Troubleshooting (docker inspect)

The `docker inspect` command is your forensic tool for container investigation:
# Check if a container is healthy
```
docker inspect --format "{{.State.Health.Status}}" db-container
```
# Find out why a container exited
```
docker inspect --format "{{.State.ExitCode}} - {{.State.Error}}" failed-service
```
# Locate all mounted volumes
```
docker inspect --format "{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}" web-app
```

#### Network Diagnostics

# Find the container's IP address in a specific network
```
docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" app-container
```
# Check if port mappings are configured correctly
```
docker inspect --format "{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{println}}{{end}}" web-server
```

#### Security Audits
# Check for privileged mode (potential security risk)
```
docker inspect --format "{{.HostConfig.Privileged}}" container-name
```
# List Linux capabilities granted to the container
```
docker inspect --format "{{.HostConfig.CapAdd}}" container-name
```

### Process Monitoring within Containers (docker top)

Monitor processes running inside containers:

# Show process resource usage
```
docker top web-server aux
```
# Focus on specific information
```
docker top db-server -o pid,user,pcpu,pmem,args
```
# Monitor process changes over time
```
watch docker top api-service
```

### Efficient Container Removal and Cleanup (docker rm)

Properly manage container lifecycle to prevent resource leaks:
# Remove all stopped containers
```
docker container prune
```
# Remove containers older than 24 hours
```
docker container prune --filter "until=24h"
```
# Remove containers, networks, and dangling images in one command
```
docker system prune
```
# Remove everything, including unused volumes (use with caution)
```
docker system prune --volumes -a
```

# Remove exited containers older than 7 days
```
docker container prune --force --filter "until=168h"
```
# Remove unused images older than 30 days
```
docker image prune --all --force --filter "until=720h"
```
# Remove unused volumes (if safe to do so)
```
docker volume prune --force
```

## Docker Volumes & Data Persistence

Docker volumes solve the problem of data persistence by providing a way to store and access data outside the container lifecycle. This ensures your data survives container restarts, crashes, or updates.

### 1. Creating a Volume (docker volume create)

Creates a named volume for storing persistent data outside of a container's filesystem:

# Create a named volume
```
docker volume create my-volume
```
# Verify volume creation
```
docker volume ls
```
Volumes persist until explicitly removed, unlike container filesystems.

### 2. Mounting Volumes in Containers (docker run -v)

Attaches a volume to a container, mapping it to a directory inside the container for persistent storage:

# Mount a volume to a container
```
docker run -d -v my-volume:/data --name vol-test busybox
```
# Test persistence by creating a file
```
docker exec vol-test sh -c "echo 'Persistent data' > /data/test.txt"
```
# Stop and remove the container
```
docker stop vol-test
```
```
docker rm vol-test
```
# Create a new container with the same volume and read the file
```
docker run -v my-volume:/data busybox cat /data/test.txt
```
Multiple containers can mount the same volume simultaneously (be careful with concurrent writes).

### 3. Inspecting and Managing Volumes (docker volume inspect)

Provides detailed information about a volume, such as its location on the host:

```
docker volume inspect my-volume
```
Use `sudo ls -l <mountpoint>` on the host to see stored data (requires root access).

### 4. Removing Volumes (docker volume rm)

Deletes a volume and its data from the system:
# Remove a specific volume
```
docker volume rm my-volume
```
# Force removal (stops containers first if needed)
```
docker volume rm -f my-volume
```
# Clean up all unused volumes
```
docker volume prune
```

### 5. Troubleshooting Docker Volumes

#### Common Issue: Volume Not Mounting

**Symptom**: Container starts but cannot access data in the expected location.

**Solution**: 
- Verify volume name with `docker volume ls`
- Check container path in application documentation
- Ensure appropriate permissions

#### Common Issue: Volume Permissions

**Symptom**: Container fails to write to mounted volume.

**Solution**: 
# Set appropriate permissions on host
```
docker run --rm -v my-volume:/data busybox chown -R 1000:1000 /data
```
# Or run container with matching user
```
docker run -v my-volume:/data -u 1000:1000 myapp
```

#### Common Issue: Cannot Delete Volume

**Symptom**: `docker volume rm` fails with "volume in use" message.

**Solution**: 
# Find containers using the volume
```
docker ps -a --filter volume=my-volume
```
# Remove those containers first
```
docker rm -f $(docker ps -a --filter volume=my-volume -q)
```
# Then remove the volume
```
docker volume rm my-volume
```

### 6. Understanding Volume Drivers

Docker volumes support different storage backends through drivers:

#### Local Driver
- **Use case**: Single-host deployments
- **Example**: `docker volume create --driver local my-volume`

#### NFS Driver
- **Use case**: Multi-host deployments with shared storage
- **Example**:
  ```
  docker volume create --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.1.100,rw \
    --opt device=:/path/to/dir \
    nfs-volume
  ```

#### AWS EBS/EFS Drivers
- **Use case**: Cloud-native applications on AWS
- **Example**:
  # Install the plugin first
  ```
  docker plugin install --grant-all-permissions rexray/ebs
  ```
  # Create an EBS volume
  ```
  docker volume create --driver rexray/ebs \
    --opt size=10 \
    --name aws-storage
  ```

### 7. Volume Security Best Practices

#### Access Control
# Run container with non-root user
```
docker run -v my-volume:/data -u 1000:1000 --name secure-app my-image
```

#### Sensitive Data
Use Docker secrets for sensitive information:
# Create a secret
```
echo "my-secret-password" | docker secret create db_password -
```
# Use the secret in a service
```
docker service create \
  --name db \
  --secret db_password \
  --mount type=volume,source=db-data,target=/var/lib/mysql \
  mysql:8
```

