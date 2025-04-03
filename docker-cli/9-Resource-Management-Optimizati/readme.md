# Docker Resource Management & Optimization

## Overview
This repository contains documentation and examples for efficiently managing and optimizing Docker container resources. Learn how to properly configure, monitor, and tune your Docker deployments for better performance and stability.

## Contents

- [Understanding Container Resource Constraints](#understanding-container-resource-constraints)
- [Limiting CPU & Memory Usage](#limiting-cpu--memory-usage)
- [Monitoring Container Performance](#monitoring-container-performance)
- [Managing System Resources](#managing-system-resources)
- [Hands-on Demonstration](#hands-on-demonstration-resource-limited-nginx-container)

## Understanding Container Resource Constraints

Docker containers share the host system's resources but can be configured to use only specific amounts of CPU, memory, and other resources. Properly setting these constraints provides several benefits:

- Prevents a single container from consuming all system resources
- Ensures fair resource distribution among multiple containers
- Makes container behavior more predictable across different environments
- Improves overall system stability and performance

## Limiting CPU & Memory Usage

### Basic Resource Limiting Commands

```
docker run --memory=512m --cpus=1 <image>
```

### Memory Limitations

**Syntax**: `--memory=<size>` or `-m`

**Examples**:
- `--memory=512m` (512 megabytes)
- `--memory=1g` (1 gigabyte)

When a container reaches its memory limit, it may be terminated by the Out-Of-Memory (OOM) killer if it attempts to allocate more memory.

### CPU Limitations

**Syntax**: `--cpus=<number>`

**Examples**:
- `--cpus=1` (one full CPU core)
- `--cpus=0.5` (half a CPU core)
- `--cpus=2.5` (two and a half CPU cores)

When a container reaches its CPU limit, it gets throttled rather than terminated, causing the container to slow down.

### Complete Example

```
docker run -d --memory=512m --cpus=1 --name resource-test nginx:latest
```

This command runs an Nginx container with:
- A maximum of 512MB memory allocation
- Access to the equivalent of one full CPU core
- A container name of "resource-test"

### Advanced Memory Options

For more granular memory control:
- `--memory-swap`: Total amount of memory plus swap the container can use
  Example: `--memory=512m --memory-swap=1g` (512MB RAM + 512MB swap)
- `--memory-reservation`: Soft limit that triggers when memory is constrained on the host
  Example: `--memory=512m --memory-reservation=400m`

## Monitoring Container Performance

### Using docker stats

The `docker stats` command provides real-time statistics about container resource usage.

# Monitor all running containers
```
docker stats
```
# Monitor a specific container
```
docker stats nginx-demo
```
# Get a single snapshot
```
docker stats --no-stream nginx-demo
```
# Custom format
```
docker stats --format "{{.Name}}: CPU {{.CPUPerc}} MEM {{.MemPerc}}"
```

### Understanding the Output

The `docker stats` command displays these metrics:
| Field             |             Description                     |
|-------------------|---------------------------------------------|
| CONTAINER ID      | Unique container identifier                 |
| NAME              | Container name                              |
| CPU %             | Percentage of host CPU capacity used        |
| MEM USAGE / LIMIT | Current memory usage and configured limit   |
| MEM %             | Percentage of memory limit used             |
| NET I/O           | Network data transferred in/out             |
| BLOCK I/O         | Disk data read/written                      |
| PIDS              | Number of processes running in the container|

## Managing System Resources

### Viewing Docker Disk Usage
# Basic disk usage information
```
docker system df
```
# Detailed breakdown by individual object
```
docker system df -v
```

### Reclaiming Disk Space

When disk usage becomes a concern, use these commands:
# Remove specific unused objects
```
docker image prune     # Remove dangling images
```
```
docker container prune # Remove stopped containers
```
```
docker volume prune    # Remove unused volumes
```

# Remove all unused objects at once
# Remove stopped containers, dangling images, networks
```
docker system prune                  
```
 # remove unused images
```
docker system prune -a               
```
# Also remove unused volumes
```
docker system prune -a --volumes     
```
## Hands-on Demonstration: Resource-Limited Nginx Container

Try this exercise to see resource constraints in action:

1. **Launch Container with Limits**:
   ```
   docker run -d --memory=256m --cpus=0.5 --name nginx-limited -p 8080:80 nginx:latest
   ```
2. **Monitor Container Performance**:
   ``
   docker stats nginx-limited
   ```
3. **Inspect the Container**:
   ```
   docker inspect nginx-limited | grep -i "memory\|cpu"
   ```
4. **Check System Resource Usage**:
   ```
   docker system df -v
   ```
5. **Access the Container**:
   ```
   curl http://localhost:8080
   ```

