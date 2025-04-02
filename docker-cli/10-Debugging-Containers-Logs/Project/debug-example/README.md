# Docker Build Debugging Example/
## Overview
This project provides an example of debugging Docker builds and inspecting running containers.
===============================================
### Structure ###
- `Dockerfile.bad`: Contains an intentional error
- `Dockerfile.fixed`: Corrected version
- `Dockerfile.debug`: Debugging-enhanced version
- `scripts/debug.sh`: Helps debug failed builds
- `scripts/inspect.sh`: Inspects running containers
- `.env`: Configurable environment variables
- `.dockerignore`: Ignoring unnecessary files
===============================================
### How to Use
# Make scripts executable:
chmod +x scripts/*.sh
# Run the debug script:
./scripts/debug.sh
===============================================
# Run the inspection script:
./scripts/inspect.sh
