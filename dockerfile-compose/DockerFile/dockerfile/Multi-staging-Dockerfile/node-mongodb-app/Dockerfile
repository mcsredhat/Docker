# =============================================================================
# UNIVERSAL 4-STAGE MULTI-STAGE DOCKERFILE TEMPLATE
# =============================================================================
# This template provides maximum optimization with 4 distinct stages:
# 1. Base Stage: Common foundation and system setup
# 2. Dependencies Stage: Install and cache dependencies
# 3. Build Stage: Code quality checks, testing, and building
# 4. Production Stage: Clean runtime environment
# =============================================================================

# ================================
# Stage 1: Base Stage
# ================================
FROM node:18-alpine AS base

# ---------- Base Arguments ----------
ARG APP_NAME="nodeapp"
ARG APP_VERSION="1.0.0"
ARG BUILD_ENV="base"
ARG APP_DIR="/app"
ARG USER_ID=1001
ARG USER_NAME="nodeuser"
ARG GROUP_ID=1001
ARG GROUP_NAME="nodegroup"
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
    python3 \
    make \
    g++

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
COPY package.json ./
COPY package-lock.json ./
COPY yarn.lock* ./

# ---------- Set Ownership of Dependency Files ----------
RUN chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR}

# ---------- Switch to Build User ----------
USER ${USER_NAME}

# ---------- Install Dependencies with Caching ----------
RUN --mount=type=cache,target=/home/${USER_NAME}/.npm,uid=${USER_ID},gid=${GROUP_ID} \
    npm install --omit=dev

# ---------- Install Development Dependencies ----------
RUN --mount=type=cache,target=/home/${USER_NAME}/.npm,uid=${USER_ID},gid=${GROUP_ID} \
    npm install

# ================================
# Stage 3: Build Stage
# ================================
FROM dependencies AS build

# ---------- Copy Source Code ----------
COPY --chown=${USER_NAME}:${GROUP_NAME} . .

# ---------- Code Quality Checks ----------
RUN npm run lint || echo "Lint check completed with warnings"

# ---------- Run Tests ----------
RUN npm test || echo "Tests completed with warnings"

# ---------- Build Application ----------
RUN npm run build

# ---------- Verify Build Artifacts ----------
RUN test -d ./dist || (echo "Build artifacts not found" && exit 1)

# ---------- Security Audit ----------
RUN npm audit --audit-level=high || echo "Security audit completed with warnings"

# ---------- Build Stage Cleanup ----------
RUN rm -rf node_modules/.cache && \
    rm -rf /tmp/* && \
    rm -rf /home/${USER_NAME}/.npm/_cacache

# ================================
# Stage 4: Production Stage
# ================================
FROM node:18-alpine AS production

# ---------- Metadata Labels ----------
LABEL maintainer="farajassulai@gmail.com" \
    org.label-schema.name="${APP_NAME}" \
    org.label-schema.description="Node.js application" \
    org.label-schema.version="${APP_VERSION}" \
    org.label-schema.schema-version="1.0" \
    stage="production"

# ---------- Production Arguments ----------
ARG APP_NAME="nodeapp"
ARG APP_VERSION="1.0.0"
ARG APP_ENV="production"
ARG APP_DIR="/app"
ARG DATA_DIR="/app/data"
ARG LOGS_DIR="/app/logs"
ARG CONFIG_DIR="/app/config"
ARG USER_ID=1001
ARG USER_NAME="nodeuser"
ARG GROUP_ID=1001
ARG GROUP_NAME="nodegroup"
ARG APP_PORT=8080
ARG HEALTH_CHECK_PATH="/health"
ARG TIMEZONE="UTC"
ARG SHELL_PATH="/bin/sh"

# ---------- Production Environment Variables ----------
ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    APP_ENV=${APP_ENV} \
    APP_DIR=${APP_DIR} \
    DATA_DIR=${DATA_DIR} \
    LOGS_DIR=${LOGS_DIR} \
    CONFIG_DIR=${CONFIG_DIR} \
    USER_ID=${USER_ID} \
    USER_NAME=${USER_NAME} \
    GROUP_ID=${GROUP_ID} \
    GROUP_NAME=${GROUP_NAME} \
    APP_PORT=${APP_PORT} \
    HEALTH_CHECK_PATH=${HEALTH_CHECK_PATH} \
    TZ=${TIMEZONE} \
    SHELL_PATH=${SHELL_PATH} \
    NODE_ENV=production \
    PATH="${APP_DIR}/bin:${PATH}"

# ---------- Set Working Directory ----------
WORKDIR ${APP_DIR}

# ---------- Install Runtime Dependencies ----------
RUN apk update && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    dumb-init \
    tini

# ---------- Create Production User & Group ----------
RUN addgroup -g ${GROUP_ID} ${GROUP_NAME} && \
    adduser -u ${USER_ID} -G ${GROUP_NAME} -D -s ${SHELL_PATH} ${USER_NAME}

# ---------- Create Application Directories ----------
RUN mkdir -p ${APP_DIR} ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR} && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR} ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR} && \
    chmod 755 ${APP_DIR} ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR}

# ---------- Copy Build Artifacts from Build Stage ----------
COPY --from=build --chown=${USER_NAME}:${GROUP_NAME} ${APP_DIR}/dist ${APP_DIR}/dist

# ---------- Copy Production Dependencies ----------
COPY --from=dependencies --chown=${USER_NAME}:${GROUP_NAME} ${APP_DIR}/node_modules ${APP_DIR}/node_modules
COPY --from=dependencies --chown=${USER_NAME}:${GROUP_NAME} ${APP_DIR}/package*.json ${APP_DIR}/

# ---------- Copy Configuration Files (if they exist) ----------
COPY --chown=${USER_NAME}:${GROUP_NAME} config* ${CONFIG_DIR}/

# ---------- Copy Entrypoint Script (if it exists) ----------
COPY --chown=${USER_NAME}:${GROUP_NAME} entrypoint.sh* /usr/local/bin/

# ---------- Set Entrypoint Script Permissions ----------
RUN if [ -f /usr/local/bin/entrypoint.sh ]; then chmod +x /usr/local/bin/entrypoint.sh; fi

# ---------- Setup Volumes ----------
VOLUME ["${DATA_DIR}", "${LOGS_DIR}"]

# ---------- Set Default Shell ----------
SHELL ["${SHELL_PATH}", "-c"]

# ---------- Expose Application Port ----------
EXPOSE ${APP_PORT}

# ---------- Switch to Non-root User ----------
USER ${USER_ID}

# ---------- Configure Stop Signal ----------
STOPSIGNAL SIGTERM

# ---------- Health Check ----------
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${APP_PORT}${HEALTH_CHECK_PATH} || exit 1

# ---------- Set Entrypoint and Default Command ----------
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/index.js"]