# Node.js MongoDB Application

A production-ready Node.js application with MongoDB integration, featuring advanced Docker containerization, comprehensive security configurations, and multi-stage builds with graceful shutdown handling.

## 🚀 Features

- **Express.js** web framework with Lodash utilities
- **MongoDB** database integration with authentication
- **Docker** containerization with 4-stage multi-stage builds
- **Graceful shutdown** handling with signal trapping
- **Production-ready** configuration with security hardening
- **Health checks** for both application and database services
- **Resource limits** and comprehensive monitoring
- **Structured logging** with rotation and service labeling
- **Development tools** including Nodemon and Jest

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Node.js 16+ (for local development)
- Git

## 🛠️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd node-mongo-app
```

### 2. Environment Configuration

Create your environment configuration file:

```bash
cp .env.example .env
```

Edit the `.env` file with your specific configurations:

```env
# Database Configuration
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=SecurePassword123!
MONGODB_URL=mongodb://admin:SecurePassword123!@mongodb:27017/myapp?authSource=admin

# Application Configuration
NODE_ENV=production
PORT=8080
LOG_LEVEL=info

# Security Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this
SESSION_SECRET=your-session-secret-change-this

# Health Check Configuration
HEALTH_CHECK_ENDPOINT=/health

# Logging Configuration
LOG_FORMAT=json
LOG_FILE=/app/logs/app.log
```

### 3. Create Required Directories

```bash
mkdir -p data/mongodb logs src
```

### 4. Create Source Files

Create a basic application structure:

```bash
# Create a basic Express application
cat > src/index.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/', (req, res) => {
    res.json({ message: 'Hello from Node.js App!', version: '1.0.0' });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
EOF
```

## 🚀 Running the Application

### Using Docker Compose (Recommended)

```bash
# Build and start all services
docker-compose up -d

# View logs in real-time
docker-compose logs -f

# View specific service logs
docker-compose logs -f node-app
docker-compose logs -f mongodb

# Stop services
docker-compose down

# Stop and remove volumes (⚠️ This will delete your data)
docker-compose down -v
```

### Local Development

```bash
# Install dependencies
npm install

# Start with nodemon for development
npm run dev

# Or build and start for production
npm run build
npm start
```

## 🏗️ Project Structure

```
.
├── src/                    # Source code
│   ├── index.js           # Main application file
│   └── *.js               # Additional application files
├── dist/                  # Built application (generated)
├── data/                  # Persistent data
│   └── mongodb/          # MongoDB data files
├── logs/                  # Application logs
├── config/               # Configuration files
├── mongo-init/           # MongoDB initialization scripts
├── docker-compose.yml    # Docker Compose configuration
├── Dockerfile           # 4-stage multi-stage Docker build
├── entrypoint.sh        # Container entrypoint with graceful shutdown
├── package.json         # Node.js dependencies and scripts
├── package-lock.json    # Locked dependencies
├── .env                 # Environment variables
└── README.md           # This file
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Application environment | `production` |
| `PORT` | Application port | `8080` |
| `MONGODB_URL` | MongoDB connection string | See `.env` |
| `MONGO_INITDB_ROOT_USERNAME` | MongoDB root username | `admin` |
| `MONGO_INITDB_ROOT_PASSWORD` | MongoDB root password | - |
| `JWT_SECRET` | JWT signing secret | - |
| `SESSION_SECRET` | Session secret | - |
| `LOG_LEVEL` | Logging level | `info` |
| `LOG_FORMAT` | Log format | `json` |
| `LOG_FILE` | Log file path | `/app/logs/app.log` |
| `HEALTH_CHECK_ENDPOINT` | Health check path | `/health` |

### Docker Multi-Stage Build

The application uses a sophisticated 4-stage Dockerfile:

1. **Base Stage**: System dependencies, user creation, and foundation setup
2. **Dependencies Stage**: Node.js package installation with npm cache mounting
3. **Build Stage**: Code quality checks, testing, building, and security auditing
4. **Production Stage**: Clean runtime environment with minimal attack surface

### Key Docker Features

- **Non-root execution** with custom user (`nodeuser:1001`)
- **Build-time caching** for faster subsequent builds
- **Security hardening** with `no-new-privileges` and proper file permissions
- **Resource constraints** (CPU and memory limits)
- **Health checks** integrated into both Dockerfile and compose
- **Graceful shutdown** handling via custom entrypoint script

## 🛡️ Security Features

### Container Security
- **Non-root user** execution (UID/GID: 1001)
- **Read-only root filesystem** support
- **Security options** (`no-new-privileges:true`)
- **Minimal attack surface** with Alpine Linux base
- **Process isolation** with proper signal handling

### Network Security
- **Custom bridge network** with subnet isolation
- **Service-to-service communication** only
- **No unnecessary port exposure**

### Resource Management
- **Memory limits**: 512MB for MongoDB, 256MB for Node.js
- **CPU limits**: 0.5 cores for MongoDB, 0.5 cores for Node.js
- **Resource reservations** for guaranteed minimum resources

## 📊 Health Checks & Monitoring

### Application Health Checks
- **Endpoint**: `/health`
- **Interval**: 30 seconds
- **Timeout**: 10 seconds
- **Retries**: 3 attempts
- **Start period**: 40 seconds (allows for application startup)

### MongoDB Health Checks
- **Command**: `mongosh --eval "db.adminCommand('ping')"`
- **Same timing configuration as application**

### Graceful Shutdown
The entrypoint script handles:
- **Signal trapping** (SIGTERM, SIGINT)
- **Process cleanup** with proper PID management
- **Pre-flight checks** before application start
- **Directory validation** for required paths

## 📝 Logging & Monitoring

### Log Configuration
- **Format**: JSON structured logging
- **Rotation**: 10MB max file size, 3 files retained
- **Service labeling** for easy log aggregation
- **Centralized collection** via Docker logging drivers

### Available Scripts

| Script | Description |
|--------|-------------|
| `npm start` | Start the production application |
| `npm run build` | Build the application |
| `npm test` | Run tests (Jest) |
| `npm run lint` | Run code linting |
| `npm run dev` | Start development server with Nodemon |

## 🔄 Development Workflow

### Building and Testing

```bash
# Build Docker images
docker-compose build

# Build without cache (for clean builds)
docker-compose build --no-cache

# Run tests in container
docker-compose run --rm node-app npm test

# Run linting
docker-compose run --rm node-app npm run lint

# Security audit
docker-compose run --rm node-app npm audit
```

### Development Mode

```bash
# Start with file watching
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Or locally with nodemon
npm install
npm run dev
```

### Debugging

```bash
# View container logs
docker-compose logs -f node-app
docker-compose logs -f mongodb

# Execute commands in running containers
docker-compose exec node-app sh
docker-compose exec mongodb mongosh -u admin -p

# Check container status
docker-compose ps

# View resource usage
docker stats
```

## 🚀 Production Deployment

### Pre-deployment Checklist

1. ✅ **Update secrets** in `.env` file
2. ✅ **Set NODE_ENV=production**
3. ✅ **Configure proper resource limits**
4. ✅ **Set up log aggregation**
5. ✅ **Configure backup strategy**
6. ✅ **Test health checks**

### Deployment Steps

```bash
# 1. Set production environment
export NODE_ENV=production

# 2. Build and deploy
docker-compose up -d

# 3. Verify deployment
curl -f http://localhost:8080/health
docker-compose ps

# 4. Monitor logs
docker-compose logs -f --tail=100
```

### Scaling

```bash
# Scale the application horizontally
docker-compose up -d --scale node-app=3

# Update with zero downtime
docker-compose up -d --force-recreate --no-deps node-app
```

## 🔧 Database Management

### MongoDB Operations

```bash
# Connect to MongoDB
docker-compose exec mongodb mongosh -u admin -p

# Create database backup
docker-compose exec mongodb mongodump --out /data/backup --authenticationDatabase admin

# Restore from backup
docker-compose exec mongodb mongorestore /data/backup --authenticationDatabase admin

# View database logs
docker-compose logs mongodb
```

### Database Initialization

Create initialization scripts in `mongo-init/`:

```bash
mkdir -p mongo-init
cat > mongo-init/init.js << 'EOF'
db = db.getSiblingDB('myapp');
db.createUser({
  user: 'appuser',
  pwd: 'apppassword',
  roles: [{ role: 'readWrite', db: 'myapp' }]
});
EOF
```

## 🔧 Maintenance & Operations

### Log Management

```bash
# View recent logs
docker-compose logs --tail=100 -f

# Clear old logs
docker system prune -f

# Rotate logs manually
docker-compose restart
```

### Updates and Patches

```bash
# Update application
git pull origin main
docker-compose build --no-cache
docker-compose up -d

# Update base images
docker-compose pull
docker-compose up -d
```

### Backup Strategy

```bash
# Create full backup
./scripts/backup.sh

# Scheduled backup (add to crontab)
0 2 * * * /path/to/project/scripts/backup.sh
```

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Port already in use** | Change `PORT` in `.env` or kill process using port |
| **Permission denied** | Check file ownership: `chown -R $(id -u):$(id -g) .` |
| **MongoDB connection failed** | Verify credentials and network connectivity |
| **Out of memory** | Increase Docker memory limits |
| **Build fails** | Clear Docker cache: `docker system prune -a` |

### Debug Commands

```bash
# Check container health
docker-compose ps
docker inspect $(docker-compose ps -q node-app)

# View detailed logs
docker-compose logs --timestamps node-app

# Test connectivity
docker-compose exec node-app ping mongodb
docker-compose exec node-app curl -f http://localhost:8080/health

# Check resource usage
docker stats $(docker-compose ps -q)

# Inspect networks
docker network ls
docker network inspect node-mongo_app-network
```

### Performance Tuning

```bash
# Monitor resource usage
docker stats --no-stream

# Optimize MongoDB
docker-compose exec mongodb mongosh --eval "db.runCommand({serverStatus: 1})"

# Application profiling
docker-compose exec node-app node --prof dist/index.js
```

## 📄 API Documentation

### Health Check Endpoint

```bash
GET /health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### Application Info

```bash
GET /
```

**Response:**
```json
{
  "message": "Hello from Node.js App!",
  "version": "1.0.0"
}
```

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure Docker builds pass
- Test in both development and production modes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Support

For support and questions:
- **Create an issue** in the repository
- **Email**: farajassulai@gmail.com
- **Documentation**: Check the `/docs` directory for additional guides

---

## 🎯 Quick Start Commands

```bash
# Complete setup and start
git clone <repo-url> && cd node-mongo-app
cp .env.example .env
mkdir -p data/mongodb logs src
echo 'const express = require("express"); const app = express(); app.get("/health", (req, res) => res.json({status: "healthy"})); app.listen(8080);' > src/index.js
docker-compose up -d
curl http://localhost:8080/health
```

**⚠️ Important**: Always update default passwords and secrets before production deployment!
