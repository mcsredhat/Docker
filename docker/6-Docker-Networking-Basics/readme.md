# Docker Networking

## Overview
This repository contains resources and examples for understanding Docker networking concepts, essential for building multi-container applications and microservices architectures.

## Learning Objectives
- Understand Docker's network types and their purposes
- Create and manage custom Docker networks
- Connect containers to networks and enable inter-container communication
- Inspect and troubleshoot network configurations
- Implement networking in practical multi-container scenarios

## Table of Contents
1. [Docker Network Types](#1-docker-network-types)
2. [Managing Docker Networks](#2-managing-docker-networks)
3. [Container Network Operations](#3-container-network-operations)
4. [Practical Networking Examples](#4-practical-networking-examples)
5. [Port Mapping](#5-port-mapping)
6. [Network Troubleshooting](#6-network-troubleshooting)

## 1. Docker Network Types
Docker provides several built-in network drivers for different use cases:

| Network Type |                             Description                                    |                    Use Case                                        |
|--------------|----------------------------------------------------------------------------|------------------------------------------------------------------|
| **bridge** | Default network driver that creates a private internal network on the host   | Standalone containers that need to communicate                   |
| **host** | Removes network isolation between container and host                           | Performance-critical applications that need host network stack   |
| **none** | Disables all networking                                                        | Containers that don't need network access                        |
| **overlay** | Connects multiple Docker daemons across hosts                               | Swarm services across multiple Docker hosts                      |
| **macvlan** | Assigns MAC addresses to containers, making them appear as physical devices | Applications that need to connect to physical network directly   |

## 2. Managing Docker Networks

### 2.1 Listing Networks
```
docker network ls [OPTIONS]
```

### 2.2 Creating a Custom Network

# Create a basic bridge network
```
docker network create app-network
```
# Create a network with custom subnet
```
docker network create --subnet=172.20.0.0/16 --gateway=172.20.0.1 custom-subnet-network
```

### 2.3 Removing a Network
```
docker network rm app-network
```

## 3. Container Network Operations

### 3.1 Connecting Containers to Networks
# Connect existing container to a network
```
docker network connect app-network web-container
```
# Start a new container on a specific network
```
docker run -d --name api-service --network=app-network my-api-image
```

### 3.2 Disconnecting Containers from Networks
```
docker network disconnect app-network web-container
```

### 3.3 Inspecting Network Details
```
docker network inspect app-network
```

## 4. Practical Networking Examples
### 4.1 Basic Network Setup
# Create a custom network
```
docker network create demo-net
``````
# Run an Nginx container on the network
```
docker run -d --name web-server --network demo-net nginx:latest
```
# Run an interactive Alpine container on the same network
```
docker run -it --name client --network demo-net alpine sh
```

### 4.2 Multi-Tier Application Setup
# Create frontend and backend networks
```
docker network create frontend-net
```
```
docker network create backend-net
```
# Start a database container on the backend network
```
docker run -d --name database \
  --network backend-net \
  -e POSTGRES_PASSWORD=mysecretpassword \
  postgres:latest
```
# Start an API container connected to both networks
```
docker run -d --name api-service \
  --network backend-net \
  my-api-image
```
# Connect the API to the frontend network as well
```
docker network connect frontend-net api-service
```
# Start a web frontend container on the frontend network
```
docker run -d --name web-frontend \
  --network frontend-net \
  -p 80:80 \
  my-frontend-image
```

## 5. Port Mapping
# Map container port 80 to host port 8080
```
docker run -d --name web -p 8080:80 nginx:latest
```
# Map container port 3000 to a random host port
```
docker run -d --name app -P my-app-image
```

## 6. Network Troubleshooting
### 6.1 Common Commands
# Check which network a container is connected to
```
docker inspect --format='{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{end}}' <container>
```
# Get the IP address of a container
```
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container>
```
# Test connectivity between containers
```
docker exec <container> ping -c 4 <target-container>
```

### 6.2 Common Issues and Solutions

| Issue                                   |         Possible Cause               |              Solution                                       |
|-----------------------------------------|--------------------------------------|-------------------------------------------------------------|
| Containers can't communicate by name    | Using default bridge network         | Use custom bridge networks for DNS resolution               |
| No internet access from container       | DNS configuration issue              | Check DNS settings or add `--dns` option                    |
| Port conflicts                          | Multiple services using same port    | Change host port mapping                                    |
| Network performance issues              | Bridge network overhead              | Consider using `host` network for performance-critical apps |
| Container can't reach external services | Firewall rules                       | Check host firewall settings                                |

