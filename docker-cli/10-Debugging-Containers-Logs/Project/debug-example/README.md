# Docker Build Debugging Example

This project demonstrates debugging techniques for Docker builds and container inspection.

## Project Structure

```
/debug-example
├── Dockerfile.bad          # Problematic Dockerfile with intentional error
├── Dockerfile.fixed        # Corrected version of the Dockerfile
├── Dockerfile.debug        # Advanced version with debugging features
├── scripts/
│   ├── debug.sh            # Build debugging script
│   └── inspect.sh          # Container inspection script
├── .env                    # Environment variables
└── README.md               # This documentation
```

## Debugging Process

### Step 1: Identify Build Failure

Run the debug script to identify build issues:

```
chmod +x scripts/debug.sh
```

```
./scripts/debug.sh
```
## This script:
- Attempts to build the problematic Dockerfile
- Shows the error message
- Allows interactive debugging of the last successful layer

### Step 2: Analyze the Failure

When a Docker build fails, important debugging information is available:
- Error code 127 typically indicates "command not found"
- Use the interactive shell to test commands
- Note the layer ID from the build output for deeper investigation

### Step 3: Verify Fixed Version

The fixed Dockerfile:
- Replaces the problematic command with a working alternative
- Implements proper cleanup steps
- Uses appropriate environment variables

## Advanced Debugging Features

The `Dockerfile.debug` includes:
- Multi-stage builds for isolation and testing
- Debug statements between commands
- Verbose package installation
- Health checks
- Proper container labeling

## Container Inspection

Use the inspection script to examine running containers:

```
chmod +x scripts/inspect.sh
```

```
./scripts/inspect.sh
```

## This script demonstrates:
- Basic container inspection
- Formatted output for specific container details
- Environment variable inspection
- Mount point verification

## Key Learning Points

### Build Debugging
- Use layer IDs to debug failed builds
- Interactive shell for testing and troubleshooting
- No-cache builds for verification
- Step-by-step debugging with echo statements

### Container Inspection
- State monitoring and exit code analysis
- Network configuration examination
- Resource settings verification
- Mount point checking

### Best Practices
- Multi-stage builds for isolation
- Debug logging between critical steps
- Environment variables for configuration
- Cleanup steps to reduce image size

## Understanding Exit Codes

Exit codes provide valuable clues about why a container stopped:
- Exit code 0: Container exited successfully
- Exit code 1: General error
- Exit code 127: Command not found
- Exit code 137: Container received SIGKILL (often OOM)
- Exit code 139: Segmentation fault

## How to Use This Project

1. Clone or create the directory structure:
   ```
   mkdir -p debug-example/scripts
   ```

2. Make scripts executable:
   ```
   chmod +x scripts/*.sh
   ```

3. Run the debug script to see the failure and fix process:
   ```
   ./scripts/debug.sh
   ```

4. Build the debug version:
   ```
   docker build -f Dockerfile.debug -t debug-example:debug .
   ```

5. Run the inspection script:
   ```
   ./scripts/inspect.sh
   ```

