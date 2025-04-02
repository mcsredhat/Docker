# Docker Image Versioning Guide

A comprehensive guide to tagging, managing, transferring, and sharing Docker images across different environments.

## Contents

1. [Understanding Image Tagging](#understanding-image-tagging)
2. [Saving & Loading Images for Transfer](#saving--loading-images-for-transfer)
3. [Pushing Images to Registries](#pushing-images-to-registries)
4. [Best Practices](#best-practices)

## Understanding Image Tagging

Docker image tags are pointers to specific image IDs in the Docker daemon's storage. When you tag an image, you're creating a human-readable reference to a specific image content hash, conceptually similar to Git branches pointing to specific commits.

### Basic Tagging Syntax

# Basic tagging syntax
```
docker tag <source-image> <target-repo>:<target-tag>
```
# Create multiple tags for the same image
```
docker tag nginx:1.23 my-nginx:production
```
```
docker tag nginx:1.23 my-nginx:1.23.0
```
```
docker tag nginx:1.23 registry.example.com:5000/my-team/nginx:1.23
```

The Docker CLI translates these tag commands into operations that update Docker's internal reference database without duplicating the actual image data.

### Tagging Best Practices
# Use semantic versioning
```
docker tag my-app:latest my-app:1.0.0
```

# Include build information
```
docker tag my-app:latest my-app:1.0.0-build.42
```

# Environment-specific tags
```
docker tag my-app:1.0.0 my-app:production
```
```
docker tag my-app:1.0.0-rc.1 my-app:staging
```

# Adding git commit information to tags for traceability
```
docker tag my-app:latest my-app:1.0.0-$(git rev-parse --short HEAD)
```

## Saving & Loading Images for Transfer
Docker's save and load commands operate at the image layer level, preserving the complete layer structure and metadata.

# Save a multi-layered application with dependencies
```
docker save -o my-full-stack.tar my-frontend:latest my-backend:latest my-db:latest
```

# Compressing large images (can reduce size by 50-70%)
```
docker save my-large-app:latest | gzip > my-large-app.tar.gz
```
# Loading compressed images
```
gunzip -c my-large-app.tar.gz | docker load
```

### What Happens Internally

1. `docker save` serializes:
   - All image layers (as individual tar files)
   - Image metadata (config.json)
   - Layer relationships (manifest.json)
   - Tag information

2. `docker load` deserializes this exact same structure, preserving all layer relationships and sharing.

### When to Use Save/Load vs Push/Pull
# Check image size before transfer
```
docker images --format "{{.Repository}}:{{.Tag}}: {{.Size}}" | grep my-app
```

- **Use save/load for:**
  - Air-gapped environments without internet
  - Very large images when bandwidth is limited
  - Testing environments where registry access is restricted
  
- **Use push/pull for:**
  - Normal deployment workflows
  - CI/CD pipelines
  - Team collaboration

## Pushing Images to Registries

When pushing images, Docker's CLI breaks the process into distinct operations.

# Login to Docker Hub (interactive)
```
docker login
```
# Login to Docker Hub (non-interactive for automation)
```
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
```
# Login to private registry
```
docker login registry.example.com:5000
```


### Working with Different Registry Types
# Docker Hub (public)
```
docker push username/my-app:1.0.0
```
```
docker tag my-app:1.0.1 username/my-app:1.0.1
```
```
docker push username/my-app:1.0.1
```

# Private registry
```
docker push registry.example.com:5000/team/my-app:1.0.0
```
# AWS ECR
docker push 012345678910.dkr.ecr.region.amazonaws.com/my-app:latest

# GitHub Container Registry
```
docker push ghcr.io/username/my-app:latest
```

### Managing Credentials

Registry credentials are stored in:
- `~/.docker/config.json` (default location)
- Credential helpers for more secure storage

### Managing Image Access Control
# Make repository private on Docker Hub
```
docker push username/my-private-app:1.0.0
```
# Then configure via Docker Hub UI

# Pull private images (after proper authentication)
```
docker pull username/my-private-app:1.0.0
```

