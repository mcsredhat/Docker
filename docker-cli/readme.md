# Comprehensive Docker Course

## Overview
This repository contains materials for a comprehensive Docker course covering everything from basic concepts to advanced container management, networking, security, and troubleshooting techniques. The course is designed for both beginners and experienced developers looking to enhance their Docker skills.

## Course Structure

##Lesson 1: Managing Docker Images
- Pulling images: `docker pull <image>`
- Listing images: `docker images`
- Removing images: `docker rmi <image>`
- Inspecting image details: `docker inspect <image>`

## Lesson 2: Tagging & Managing Image Versions
- Tagging images: `docker tag <image> <repo>:<version>`
- Saving & loading images: `docker save`, `docker load`
- Pushing images to Docker Hub: `docker push <repo>:<tag>`

## Lesson 3: Running and Managing Containers
- Running a container: `docker run <image>`
- Running in detached mode: `docker run -d <image>`
- Running in interactive mode: `docker run -it <image> bash`
- Stopping a container: `docker stop <container_id>`
- Restarting a container: `docker restart <container_id>`

## Lesson 4: Viewing & Controlling Containers
- Listing all containers: `docker ps -a`
- Viewing container logs: `docker logs <container_id>`
- Inspecting container details: `docker inspect <container_id>`
- Checking running processes: `docker top <container_id>`
- Removing containers: `docker rm <container_id>`

**Hands-On Exercise**: Run and manage a Python or Node.js container

## Lesson 5: Docker Volumes & Data Persistence
- Creating a volume: `docker volume create <volume>`
- Mounting volumes in containers: `docker run -v <volume>:/data <image>`
- Inspecting and managing volumes: `docker volume inspect <volume>`
- Removing volumes: `docker volume rm <volume>`

**Project**: Use volumes for persistent database storage


## Lesson 6: Docker Networking Basics
- Listing networks: `docker network ls`
- Creating a custom network: `docker network create <network-name>`
- Connecting containers to a network: `docker network connect <network> <container>`
- Inspecting network details: `docker network inspect <network-name>`

## Lesson 7: Running Multi-Container Applications
- Connecting two containers (e.g., Node.js & MongoDB)
- Using bridge and host networks
- Port mapping: `docker run -p 8080:80 <image>`

**Project**: Deploy a MySQL & PHP web app using networking

## Lesson 8: Docker Security Best Practices
- Running containers as non-root users
- Scanning images for vulnerabilities: `docker scan <image>`
- Restricting container permissions with AppArmor & seccomp

## Lesson 9: Resource Management & Optimization
- Limiting CPU & Memory Usage: `docker run --memory=512m --cpus=1`
- Monitoring container performance: `docker stats`
- Viewing system resource usage: `docker system df`

**Hands-On**: Secure and optimize a running container


#### Lesson 10: Debugging Containers & Logs
- Viewing logs: `docker logs <container_id>`
- Debugging failing builds: `docker build --no-cache .`
- Checking container issues: `docker inspect <container>`

#### Lesson 11: Connecting to Running Containers
- Executing commands inside a container: `docker exec -it <container> sh`
- Attaching to a running container: `docker attach <container>`

## Prerequisites
- Basic command line knowledge
- Familiarity with Linux concepts
- A computer with Docker installed (instructions provided)

