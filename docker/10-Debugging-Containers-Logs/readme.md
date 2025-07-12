# Docker Container Debugging & Logging

## Overview
This repository provides comprehensive documentation and examples for debugging Docker containers and implementing effective logging strategies. Learn essential techniques for troubleshooting container issues, analyzing logs, and investigating build failures.

## Contents

- [Understanding Container Logs](#understanding-container-logs)
- [Using the Docker Logs Command](#using-the-docker-logs-command)
- [Log Persistence Strategies](#log-persistence)
- [Troubleshooting Failed Container Builds](#troubleshooting-failed-container-builds)
- [Examining Intermediate Containers](#examining-intermediate-containers)

## Understanding Container Logs

Container logs capture the stdout and stderr output streams from the main process running inside a container. These logs provide critical insights into:
- Application startup messages and errors
- Runtime behavior and warnings
- Performance issues
- Security alerts
- Application-specific information

Since containers are designed to be ephemeral, logs often serve as the primary diagnostic tool when problems occur.

## Using the Docker Logs Command

The `docker logs` command is your first line of defense when troubleshooting container issues.

**Basic Syntax:**
```
docker logs <container-id-or-name> [options]
```

**Key Options:**

|     Option              |   Description                   |                            Example                                  |
|-------------------------|---------------------------------|---------------------------------------------------------------------|
| `--follow` or `-f `     | Stream logs in real-time        | `docker logs -f my-container`                                       |
| `--tail <n>`            | Show only the last n lines      | `docker logs --tail 100 my-container`                               |
| `--since <time>`        | Show logs since specified time  | `docker logs --since 30m my-container`                              |
| `--until <time>`        | Show logs before specified time | `docker logs --until "2023-05-01T10:00:00" my-container`            |
| `--timestamps` or `-t`  | Add timestamps                  | `docker logs -t my-container`                                       |

### Practical Examples

#### Basic Log Retrieval

# Start a container
```
docker run -d --name web-server nginx:latest
```
# View all logs
```
docker logs web-server
```
This displays all logs from the container's stdout and stderr, showing Nginx startup messages and access logs.

#### Real-Time Log Monitoring
# Stream logs in real-time
```
docker logs -f web-server
```
# In another terminal, generate traffic
```
curl http://localhost:80
```
# Watch as new logs appear (press Ctrl+C to exit)
This is particularly useful during development or when troubleshooting intermittent issues.

#### Viewing Recent Log Entries
# Show only the last 10 lines
```
docker logs --tail 10 web-server
```
# Show logs from the last 5 minutes
```
docker logs --since 5m web-server
```
These commands help when you need to focus on recent events without filtering through extensive output.

## Log Persistence

By default, Docker logs are stored using the json-file logging driver, which keeps logs on the host filesystem. However, container logs are lost when a container is removed unless you:

1. Configure log rotation to prevent excessive disk usage:
   ```
   docker run --log-opt max-size=10m --log-opt max-file=3 nginx
   ```
2. Use a logging driver that sends logs to external systems:
   ```
   docker run --log-driver=syslog nginx
   ```
3. Mount a volume to persist logs:
   ```bash
   docker run -v /path/on/host:/var/log/nginx nginx
   ```

## Troubleshooting Failed Container Builds

### Common Build Failure Causes

Docker build failures typically fall into several categories:

1. **Syntax errors** in the Dockerfile
2. **Network issues** during package installation
3. **Missing dependencies** or incompatible versions
4. **Permission problems** when accessing files or directories
5. **Resource limitations** (disk space, memory)
6. **Cached layers** hiding changes or masking issues

### Using `--no-cache` to Debug Builds

When builds fail unexpectedly or when you need to ensure a completely fresh build, the `--no-cache` option is invaluable.
```
docker build --no-cache -t my-image:latest .
```
This forces Docker to execute each instruction without using any cached layers, which can reveal issues that might be hidden by outdated cache.

## Examining Intermediate Containers

When a build fails, Docker preserves the last successful intermediate container, which you can examine to debug the issue.

# From the build output, note the last successfully built layer ID
# Example output: Step 3/7 : RUN apt-get update
#  ---> Running in a72f40c16532
#  ---> 6b1abe3a6d6c

# Use the layer ID to start an interactive shell
```
docker run -it 6b1abe3a6d6c /bin/bash
```
# Now you can explore the container state and try commands manually

