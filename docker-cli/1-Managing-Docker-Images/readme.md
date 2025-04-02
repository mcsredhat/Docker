# Docker Image Management Lesson
## Objective
Master the essential Docker CLI commands for managing images, enabling you to retrieve, view, delete, and analyze images effectively in real-world scenarios.

## 1. Pulling Images (docker pull \<image>)
# Pull from a specific registry
```
docker pull mcr.microsoft.com/dotnet/aspnet:6.0
```
# Pull multiple tags at once
```
docker pull -a redis
```
Additionally, I'd explain the concept of image digests, which are content-addressable identifiers:
# Pull by digest (guarantees the exact image version)
```
docker pull ubuntu@sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac
```
## 2. Listing Images (docker images)
# Find large images taking up space
```
docker images --format "{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -hr | head -5
```
# List images with creation date for auditing
```
docker images --format "{{.CreatedSince}}\t{{.Repository}}:{{.Tag}}"
```
```
docker images --format "{{.ID}} {{.Repository}}" | !grep "<none>"
```
The `--format` flag with Go templates is powerful for customizing output - worth highlighting as a productivity booster.

## 3. Removing Images (docker rmi \<image>)
# Remove all unused images (not just dangling ones)
```
docker images --format "{{.ID}} {{.Size}}" | awk '$2+0 <= 120 {print $1}' | xargs docker rmi -f
```
```
docker images --format "{{.ID}} {{.CreatedSince}}" | grep "10 years ago" | awk '{print $1}' | xargs docker rmi -f
```
```
docker image prune -a
```
# Remove images matching a pattern
```
docker images | grep "pattern" | awk '{print $3}' | xargs docker rmi
```
```
docker images | grep "32bit" | awk '{ print $3}' | xargs docker rmi -f
```
```
docker images | grep "10 years ago" | awk '{print $3}' | xargs docker rmi -f
```
I'd also explain the important distinction between:
- `docker image prune`: Removes dangling images (untagged layers)
- `docker image prune -a`: Removes ALL unused images (potentially reclaiming significant disk space)

## 4. Inspecting Image Details (docker inspect \<image>)
 inspection commands:
# Check image layers and their sizes
```
docker history nginx:latest
```
# Extract all environment variables
```
docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' nginx
```
# Find image entry point and default command
```
docker inspect --format='Entrypoint: {{.Config.Entrypoint}} | CMD: {{.Config.Cmd}}' nginx
```
The `docker history` command complements `docker inspect` by showing the command that created each layer and its size contribution.

# Inspect full image details
```
docker inspect <image>
```
# Get Image ID	
```
docker inspect --format="{{.Id}}" <image>
```
# Get OS & Architecture	
```
docker inspect --format='{{.Architecture}}/{{.Os}}' <image>
```
# Get Entrypoint & CMD	
```
docker inspect --format='Entrypoint: {{.Config.Entrypoint}}' nginx
```
# List Environment Variables	
```
docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' <image>
```
#Show Exposed Ports	
```
docker inspect --format='{{range $port, $_ := .Config.ExposedPorts}}{{$port}} {{end}}' <image>
```
#Show Image Labels
```
docker inspect --format='{{json .Config.Labels}}' <image>
```
# See Image History (Layers)	
```
docker history <image>
```
# Save Image Details to File	
```
docker inspect <image> > details.json
```
```
docker inspect --format="{{.Id}}\{{.RepoDigests}}\{{.RepoTags}}" nginx
```
# output = sha256:53a18edff8091d5faff1e42b4d885bc5f0f897873b0b8f0ace236cd5930819b0\[nginx@sha256:57a563126c0fd426346b02e5aa231ae9e5fd66f2248b36553207a0eca1403fde]\[nginx:latest]

```
 docker inspect --format='{{.Created}}' nginx
```
# output = (2025-02-05T21:27:16Z)
```
 docker inspect --format='range : {{.Config.Env}}' nginx
```
# output = range : [PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin NGINX_VERSION=1.27.4 NJS_VERSION=0.8.9 NJS_RELEASE=1~bookworm PKG_RELEASE=1~bookworm DYNPKG_RELEASE=1~bookworm]
```
docker inspect --format='range : {{.Config.ExposedPorts}}' nginx
```
# output = range : map[80/tcp:{}]
```
docker inspect --format='range : {{.Config.Entrypoint}}' nginx
```
# output range : [/docker-entrypoint.sh]
