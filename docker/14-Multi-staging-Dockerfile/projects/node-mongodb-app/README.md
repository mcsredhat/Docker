# Node.js MongoDB Application

A production-ready Node.js application with MongoDB integration, featuring Docker containerization, comprehensive security configurations, and multi-stage builds.

## 🚀 Features

- **Express.js** web framework
- **MongoDB** database integration
- **Docker** containerization with multi-stage builds
- **Production-ready** configuration
- **Security hardened** containers
- **Health checks** for both services
- **Graceful shutdown** handling
- **Resource limits** and monitoring
- **Comprehensive logging** configuration

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 18+ (for local development)
- Git

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd node-mongo-app
```

### 2. Environment Configuration

Copy the example environment file and configure your settings:

```bash
cp .env.example .env
```

Edit the `.env` file with your specific configurations:

```env
# Database Configuration
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=your-secure-password
MONGODB_URL=mongodb://admin:your-secure-password@mongodb:27017/myapp?authSource=admin

# Application Configuration
NODE_ENV=production
PORT=8080
LOG_LEVEL=info

# Security Configuration
JWT_SECRET=your-super-secret-jwt-key
SESSION_SECRET=your-session-secret

# Health Check Configuration
HEALTH_CHECK_ENDPOINT=/health
```

### 3. Create Required Directories

```bash
mkdir -p data/mongodb logs
```

## 🚀 Running the Application

### Using Docker Compose (Recommended)

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Local Development

```bash
# Install dependencies
npm install

# Build the application
npm run build

# Start the application
npm start
```

## 🏗️ Project Structure

```
.
├── src/                    # Source code
│   └── *.js               # Application files
├── dist/                  # Built application (generated)
├── data/                  # Persistent data
│   └── mongodb/          # MongoDB data files
├── logs/                  # Application logs
├── config/               # Configuration files
├── docker-compose.yml    # Docker Compose configuration
├── Dockerfile           # Multi-stage Docker build
├── entrypoint.sh        # Container entrypoint script
├── package.json         # Node.js dependencies
├── package-lock.json    # Locked dependencies
└── .env                 # Environment variables
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Application environment | `production` |
| `PORT` | Application port | `8080` |
| `MONGODB_URL` | MongoDB connection string | See `.env` |
| `JWT_SECRET` | JWT signing secret | - |
| `SESSION_SECRET` | Session secret | - |
| `LOG_LEVEL` | Logging level | `info` |
| `HEALTH_CHECK_ENDPOINT` | Health check path | `/health` |

### Docker Configuration

The application uses a 4-stage multi-stage Dockerfile:

1. **Base Stage**: System dependencies and user setup
2. **Dependencies Stage**: Node.js package installation
3. **Build Stage**: Code quality checks, testing, and building
4. **Production Stage**: Clean runtime environment

## 🛡️ Security Features

- **Non-root user** execution in containers
- **Read-only root filesystem** support
- **Security options** (`no-new-privileges`)
- **Resource limits** (CPU and memory)
- **Network isolation** with custom bridge network
- **Secrets management** via environment variables

## 📊 Health Checks

Both services include comprehensive health checks:

- **MongoDB**: `mongosh --eval "db.adminCommand('ping')"`
- **Node.js App**: HTTP GET to `/health` endpoint

Health check configuration:
- Interval: 30 seconds
- Timeout: 10 seconds
- Retries: 3
- Start period: 40 seconds

## 📝 Logging

Structured logging with JSON format:

- **Log rotation**: 10MB max size, 3 files retained
- **Service labeling** for container identification
- **Centralized logging** via Docker logging drivers

## 🔄 Development Workflow

### Building the Application

```bash
# Build Docker images
docker-compose build

# Build without cache
docker-compose build --no-cache

# Build specific service
docker-compose build node-app
```

### Running Tests

```bash
# Run tests in container
docker-compose run --rm node-app npm test

# Run linting
docker-compose run --rm node-app npm run lint
```

### Debugging

```bash
# View container logs
docker-compose logs -f node-app
docker-compose logs -f mongodb

# Execute commands in running container
docker-compose exec node-app sh
docker-compose exec mongodb mongosh
```

## 🚀 Deployment

### Production Deployment

1. **Set production environment variables**:
   ```bash
   export NODE_ENV=production
   ```

2. **Build and deploy**:
   ```bash
   docker-compose -f docker-compose.yml up -d
   ```

3. **Verify deployment**:
   ```bash
   curl http://localhost:8080/health
   ```

### Scaling

```bash
# Scale the application
docker-compose up -d --scale node-app=3
```

## 🔧 Maintenance

### Database Backup

```bash
# Create backup
docker-compose exec mongodb mongodump --out /data/backup

# Restore backup
docker-compose exec mongodb mongorestore /data/backup
```

### Log Management

```bash
# View logs
docker-compose logs --tail=100 -f

# Clear logs
docker-compose down && docker system prune -f
```

### Updates

```bash
# Update application
git pull origin main
docker-compose build
docker-compose up -d
```

## 🐛 Troubleshooting

### Common Issues

1. **Port conflicts**: Change `PORT` in `.env` file
2. **Permission issues**: Check file ownership and permissions
3. **Memory issues**: Adjust resource limits in `docker-compose.yml`
4. **Database connection**: Verify MongoDB credentials and network connectivity

### Debug Commands

```bash
# Check container status
docker-compose ps

# Inspect service configuration
docker-compose config

# View resource usage
docker stats

# Check networks
docker network ls
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📧 Support

For support and questions, please open an issue in the repository or contact the maintainer at farajassulai@gmail.com.

---

**Note**: Remember to update passwords and secrets before deploying to production!
