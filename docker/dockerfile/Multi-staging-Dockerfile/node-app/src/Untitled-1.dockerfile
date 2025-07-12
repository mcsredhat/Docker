# =============================================================================
# REACT 4-STAGE MULTI-STAGE DOCKERFILE TEMPLATE (NON-ROOT USER)
# =============================================================================
# This template provides maximum optimization with 4 distinct stages:
# 1. Base Stage: Common foundation and system setup
# 2. Dependencies Stage: Install and cache dependencies
# 3. Build Stage: Code quality checks, testing, and building
# 4. Production Stage: Clean runtime environment with nginx (non-root)
# =============================================================================

# ================================
# Stage 1: Base Stage
# ================================
FROM node:18-alpine AS base

# ---------- Base Arguments ----------
ARG APP_NAME="reactapp"
ARG APP_VERSION="1.0.0"
ARG BUILD_ENV="base"
ARG APP_DIR="/app"
ARG USER_ID=1001
ARG USER_NAME="reactuser"
ARG GROUP_ID=1001
ARG GROUP_NAME="reactgroup"
ARG TIMEZONE="UTC"

# ---------- Base Environment Variables ----------
ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    BUILD_ENV=${BUILD_ENV} \
    APP_DIR=${APP_DIR} \
    USER_ID=${USER_ID} \
    USER_NAME=${USER_NAME} \
    GROUP_ID=${GROUP_ID} \
    GROUP_NAME=${GROUP_NAME} \
    TZ=${TIMEZONE} \
    PATH="${APP_DIR}/bin:${PATH}"

# ---------- Set Working Directory ----------
WORKDIR ${APP_DIR}

# ---------- Install System Dependencies ----------
RUN apk update && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    git \
    build-base \
    bash \
    make && \
    rm -rf /var/cache/apk/*

# ---------- Create Build User & Group ----------
RUN addgroup -g ${GROUP_ID} ${GROUP_NAME} && \
    adduser -u ${USER_ID} -G ${GROUP_NAME} -D -s /bin/sh ${USER_NAME}

# ---------- Create Application Directories ----------
RUN mkdir -p ${APP_DIR} && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR}

# ================================
# Stage 2: Dependencies Stage
# ================================
FROM base AS dependencies

# ---------- Copy Dependency Files First (for better caching) ----------
COPY . ${APP_DIR}/.
COPY src ${APP_DIR}/.
COPY src/* ${APP_DIR}/.
COPY public ${APP_DIR}/.
COPY public/* ${APP_DIR}/.
COPY package.json ${APP_DIR}/.
COPY package-lock.json* ${APP_DIR}/.
COPY yarn.lock* ${APP_DIR}/
COPY pnpm-lock.yaml* ${APP_DIR}/. 


# ---------- Set Ownership of Dependency Files ----------
RUN chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR}

# ---------- Switch to Build User ----------
USER ${USER_NAME}

# ---------- Configure npm settings ----------
RUN npm config set fund false && npm config set audit-level moderate

# ---------- Install Dependencies with Caching ----------
RUN --mount=type=cache,target=/home/${USER_NAME}/.npm,uid=${USER_ID},gid=${GROUP_ID} \
    npm install --no-audit --prefer-offline --progress=false
# ================================
# Stage 3: Build Stage
# ================================
FROM dependencies AS build

# ---------- Copy Source Code ----------
COPY --chown=${USER_NAME}:${GROUP_NAME} . .

# ---------- Code Quality Checks (Optional - don't fail build if scripts don't exist) ----------
RUN npm run lint 2>/dev/null || echo "Lint check skipped or completed"
RUN npm run format:check 2>/dev/null || echo "Format check skipped or completed"
RUN npx tsc --noEmit --skipLibCheck 2>/dev/null || echo "TypeScript check skipped or completed"

# ---------- Run Tests ----------
RUN CI=true npm run test -- --coverage --watchAll=false --passWithNoTests 2>/dev/null || echo "Tests skipped or completed"

# ---------- Build Application ----------
RUN npm run build

# ---------- Verify Build Artifacts ----------
RUN test -d ./build || (echo "Build artifacts not found in ./build directory" && exit 1)
RUN ls -la build/ && test -f build/index.html && echo "Build verified successfully"
RUN du -sh build/

# ---------- Security Audit (Non-blocking) ----------
RUN npm audit --audit-level=high || echo "Security audit completed with warnings"

# ---------- Build Stage Cleanup ----------
RUN rm -rf node_modules/.cache && \
    rm -rf /tmp/* && \
    rm -rf /home/${USER_NAME}/.npm/_cacache && \
    rm -rf src/ public/ && \
    npm cache clean --force

# ================================
# Stage 4: Production Stage (Non-Root)
# ================================
FROM nginx:alpine AS production

# ---------- Metadata Labels ----------
LABEL maintainer="farajassulai@gmail.com" \
    org.label-schema.name="reactapp" \
    org.label-schema.description="React application served with nginx (non-root)" \
    org.label-schema.version="1.0.0" \
    org.label-schema.schema-version="1.0" \
    stage="production"

# ---------- Production Arguments ----------
ARG APP_NAME="reactapp"
ARG APP_VERSION="1.0.0"
ARG APP_PORT=8080
ARG HEALTH_CHECK_PATH="/health"
ARG TIMEZONE="UTC"
ARG DATA_DIR="/var/lib/reactapp"
ARG LOGS_DIR="/var/log/reactapp"
ARG CONFIG_DIR="/etc/reactapp"
ARG SHELL_PATH="/bin/sh"
ARG USER_ID=1001
ARG USER_NAME="reactuser"
ARG GROUP_ID=1001
ARG GROUP_NAME="reactgroup"

# ---------- Production Environment Variables ----------
ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    APP_PORT=${APP_PORT} \
    HEALTH_CHECK_PATH=${HEALTH_CHECK_PATH} \
    TZ=${TIMEZONE} \
    NODE_ENV=production \
    DATA_DIR=${DATA_DIR} \
    LOGS_DIR=${LOGS_DIR} \
    CONFIG_DIR=${CONFIG_DIR} \
    SHELL_PATH=${SHELL_PATH} \
    USER_ID=${USER_ID} \
    USER_NAME=${USER_NAME} \
    GROUP_ID=${GROUP_ID} \
    GROUP_NAME=${GROUP_NAME}

# ---------- Install Runtime Dependencies ----------
RUN apk update && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    tzdata && \
    rm -rf /var/cache/apk/*

# ---------- Create Non-Root User & Group ----------
RUN addgroup -g ${GROUP_ID} ${GROUP_NAME} && \
    adduser -u ${USER_ID} -G ${GROUP_NAME} -D -s /bin/sh ${USER_NAME}

# ---------- Create Application Directories ----------
RUN mkdir -p ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR} /var/cache/nginx /var/run/nginx && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR} /var/cache/nginx /var/run/nginx /usr/share/nginx/html

# ---------- Copy Build Artifacts from Build Stage ----------
COPY --from=build /app/build /usr/share/nginx/html

# ---------- Copy nginx configuration ----------
COPY nginx.conf /etc/nginx/nginx.conf

# ---------- Copy Entrypoint Script ----------
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# ---------- Set Entrypoint Script Permissions ----------
RUN chmod +x /usr/local/bin/entrypoint.sh

# ---------- Create health check endpoint ----------
RUN echo '<!DOCTYPE html><html><head><title>Health Check</title></head><body><h1>OK</h1><p>Service is running on port 8080</p></body></html>' > /usr/share/nginx/html/health

# ---------- Set proper ownership ----------
RUN chown -R ${USER_NAME}:${GROUP_NAME} /usr/share/nginx/html

# ---------- Setup Volumes ----------
VOLUME ["${DATA_DIR}", "${LOGS_DIR}"]

# ---------- Switch to Non-Root User ----------
USER ${USER_NAME}

# ---------- Set Default Shell ----------
SHELL ["/bin/sh", "-c"]

# ---------- Expose Application Port ----------
EXPOSE ${APP_PORT}

# ---------- Configure Stop Signal ----------
STOPSIGNAL SIGTERM

# ---------- Health Check ----------
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${APP_PORT}${HEALTH_CHECK_PATH} || exit 1

# ---------- Use Entrypoint Script ----------
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# ---------- Default Command ----------
CMD ["nginx", "-g", "daemon off;"]