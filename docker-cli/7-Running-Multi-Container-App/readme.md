# Docker Multi-Container Applications

This repository demonstrates running multi-container applications with Docker, following microservices architecture patterns.

## Table of Contents

- [Introduction](#introduction)
- [Container Communication Fundamentals](#container-communication-fundamentals)
  - [Why Use Multiple Containers](#why-use-multiple-containers)
  - [Communication Methods](#communication-methods)
- [Docker Networking](#docker-networking)
  - [Custom Bridge Networks](#custom-bridge-networks)
  - [Container Communication](#container-communication)
  - [Network Types](#network-types)
- [External Access with Port Mapping](#external-access-with-port-mapping)
  - [Port Mapping Fundamentals](#port-mapping-fundamentals)
  - [Managing Port Mappings](#managing-port-mappings)
  - [Common Service Ports](#common-service-ports)
- [Example: Node.js with MongoDB](#example-nodejs-with-mongodb)

## Introduction

Modern applications are typically composed of interconnected services: web servers, application servers, databases, caches, and more. Docker excels at managing these complex environments, providing component isolation while enabling effective communication.

## Container Communication Fundamentals

### Why Use Multiple Containers

The microservices architecture separates applications into loosely coupled services that can be:
- Developed by independent teams
- Deployed on different schedules
- Scaled according to individual service needs
- Maintained with minimal cross-service dependencies
- Written in the most appropriate programming language for each service

Docker supports this approach by enabling each service to run in its own container with:
- Completely isolated environments
- Independent dependency management
- Granular resource allocation and scaling
- Simplified maintenance and updates

### Communication Methods

Containers can communicate through several mechanisms:

1. **Docker Networks**: Virtual networks connecting containers while maintaining isolation
2. **Environment Variables**: Secure way to pass connection information and credentials
3. **Shared Volumes**: Enable containers to share files and persistent data
4. **Docker Compose**: Define multi-container applications declaratively

## Docker Networking

### Custom Bridge Networks

**Purpose**: Create isolated networks for related containers with enhanced communication features.

**Key Benefits**:
- Automatic DNS resolution (containers can reference each other by name)
- Improved isolation from unrelated containers
- Custom IP address management
- Dynamic container connection/disconnection at runtime

**Creating Your First Custom Network**:
# Create a custom bridge network
```
docker network create app-network
```
# Verify the network was created
```
docker network ls
```

### Container Communication
Containers on the same custom bridge network can communicate using container names as hostnames, simplifying service discovery.

### Network Types
Docker offers different network types for various application requirements:

#### Bridge Networks (Default or Custom)

**Characteristics**:
- Creates a private internal network on the host
- Each container receives its IP address
- Containers on the same bridge network can communicate freely
- Requires port mapping for external access

**Example**:
# Using a custom bridge network (recommended approach)
```
docker network create my-bridge
```
```
docker run -d --name web-custom --network my-bridge nginx:latest
```

#### Host Network
**Characteristics**:
- Removes network isolation between container and host
- Container shares the host's network namespace directly
- No port mapping required (uses host ports directly)
- Potential port conflicts with host services

**Example**:
```bash
docker run -d --name web-host --network host nginx:latest
```
# Now accessible directly on host's port 80 (if not already in use)


#### Network Comparison

| Feature        | Custom Bridge      | Default Bridge |         Host                  |
|----------------|--------------------|----------------|-------------------------------|
| Isolation      | Strong             | Strong         |            Minimal            |
| DNS Resolution | Automatic          | Manual         |            Uses host's        |
| Performance    | Good               | Good           |            Excellent          |
| Port Mapping   | Required           | Required       |            Not needed         |
| Security       | Good               | Good           |            Reduced            |
| Ideal Use Case | Most applications  | Legacy support | Performance-critical services |

## External Access with Port Mapping

### Port Mapping Fundamentals

**Purpose**: Allow external systems to access services running inside containers.
**Basic Syntax**:
```
docker run -p <host-port>:<container-port> <image>
```

**Common Port Mapping Examples**:
# Map container's port 80 to host's port 8080
```
docker run -d --name web -p 8080:80 nginx:latest
```
# Map multiple ports
```
docker run -d --name web-multi -p 8080:80 -p 8443:443 nginx:latest
```
# Map to a specific host IP address (restrict access)
```
docker run -d --name web-restricted -p 127.0.0.1:8080:80 nginx:latest
```
# Map to a random available port on the host
```
docker run -d --name web-dynamic -p 80 nginx:latest
```

### Managing Port Mappings
# View all mapped ports for a specific container
```
docker port web
```
# View detailed port mapping information
```
docker inspect -f '{{range $k, $v := .NetworkSettings.Ports}}{{$k}} -> {{(index $v 0).HostPort}}{{"\n"}}{{end}}' web
```

### Common Service Ports

| Service                | Default Container Port | Typical Host Mapping |                    Notes                        |
|------------------------|------------------------|----------------------|-------------------------------------------------|
| Web Server (HTTP)      |       80               |       8080:80        | Using 8080 avoids privileged port restrictions  |
| Web Server (HTTPS)     |       443              |       8443:443       | Using 8443 avoids privileged port restrictions  |
| Node.js                |       3000             |       3000:3000      | Common for Express applications                 |
| MySQL/MariaDB          |       3306             |       3306:3306      | Database access                                 |
| PostgreSQL             |       5432             |       5432:5432      | Database access                                 |
| MongoDB                |       27017            |       27017:27017    | Database access                                 |
| Redis                  |       6379             |       6379:6379      | Caching and message broker                      |
| Elasticsearch          |       9200             |       9200:9200      | Search engine HTTP interface                    |

## Example: Node.js with MongoDB

Here's a complete example of running a Node.js application with MongoDB:
# Step 1: Create a network for our application
```
docker network create app-network
```
# Step 2: Start the MongoDB container on our network
```
docker run -d \
  --name mongodb \
  --network app-network \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  mongo:latest
```
# Step 3: Start our Node.js application container on the same network
```
docker run -d \
  --name node-app \
  --network app-network \
  -e MONGODB_URI=mongodb://admin:password@mongodb:27017 \
  -p 3000:3000 \
  my-node-app:latest
```

**Important Points**:
- The Node.js application can connect to MongoDB using `mongodb` as the hostname
- No need to track IP addresses or ports internally
- DNS resolution happens automatically within the Docker network
- Connection details passed securely via environment variables
- External access to the Node.js app available on port 3000
