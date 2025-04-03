# Docker Container Management Guide

This repository contains documentation and scripts for efficiently managing Docker containers in development and production environments.

## Table of Contents

- [Understanding Container Visibility](#understanding-container-visibility-docker-ps)
- [Working with Container Logs](#deep-dive-into-container-logs-docker-logs)
- [Container Inspection and Troubleshooting](#container-inspection-and-troubleshooting-docker-inspect)
- [Process Monitoring](#process-monitoring-within-containers-docker-top)
- [Container Cleanup](#efficient-container-removal-and-cleanup-docker-rm)

## Understanding Container Visibility (docker ps)

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
## Deep Dive into Container Logs (docker logs)

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

### Log Management for Production
# Run with log driver configuration
```
docker run -d --log-driver=syslog --log-opt syslog-address=udp://logserver:514 nginx
```

# Configure log rotation to prevent disk space issues
```
docker run -d --log-opt max-size=10m --log-opt max-file=3 nginx
```

## Container Inspection and Troubleshooting (docker inspect)
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

### Network Diagnostics
# Find the container's IP address in a specific network
```
docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" app-container
```
# Check if port mappings are configured correctly
```
docker inspect --format "{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{println}}{{end}}" web-server
```

### Security Audits
# Check for privileged mode (potential security risk)
```
docker inspect --format "{{.HostConfig.Privileged}}" container-name
```
# List Linux capabilities granted to the container
```
docker inspect --format "{{.HostConfig.CapAdd}}" container-name
```

## Process Monitoring within Containers (docker top)

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

## Efficient Container Removal and Cleanup (docker rm)

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

### Scheduled Cleanup 
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

