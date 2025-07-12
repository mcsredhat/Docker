# =============================================================================
# GO 4-STAGE MULTI-STAGE DOCKERFILE TEMPLATE (NON-ROOT USER)
# =============================================================================
# This template provides maximum optimization with 4 distinct stages:
# 1. Base Stage: Common foundation and system setup
# 2. Dependencies Stage: Install and cache dependencies
# 3. Build Stage: Code quality checks, testing, and building
# 4. Production Stage: Clean runtime environment (non-root)
# =============================================================================

# ================================
# Stage 1: Base Stage
# ================================
FROM golang:1.21-alpine AS base

# ---------- Base Arguments ----------
ARG APP_NAME="goapp"
ARG APP_VERSION="1.0.0"
ARG BUILD_ENV="base"
ARG APP_DIR="/app"
ARG USER_ID=1001
ARG USER_NAME="gouser"
ARG GROUP_ID=1001
ARG GROUP_NAME="gogroup"
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
    PATH="${APP_DIR}/bin:${PATH}" \
    CGO_ENABLED=0 \
    GOOS=linux

# ---------- Set Working Directory ----------
WORKDIR ${APP_DIR}

# ---------- Install System Dependencies ----------
RUN apk update && apk add --no-cache \
    ca-certificates \
    curl \
    wget \
    git \
    tzdata \
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

# ---------- Copy Go Module Files First (for better caching) ----------
COPY go.mod go.sum* ${APP_DIR}/

# ---------- Set Ownership of Module Files ----------
RUN chown -R ${USER_NAME}:${GROUP_NAME} ${APP_DIR}

# ---------- Switch to Build User ----------
USER ${USER_NAME}

# ---------- Download Go Dependencies with Caching ----------
RUN --mount=type=cache,target=/go/pkg/mod,uid=${USER_ID},gid=${GROUP_ID} \
    go mod download && go mod verify

# ================================
# Stage 3: Build Stage
# ================================
FROM dependencies AS build

# ---------- Copy Source Code ----------
COPY --chown=${USER_NAME}:${GROUP_NAME} . ${APP_DIR}/

# ---------- Code Quality Checks ----------
RUN go vet ./...
RUN go fmt ./...

# ---------- Run Tests ----------
RUN go test -v -race -coverprofile=coverage.out ./...

# ---------- Build Application ----------
RUN --mount=type=cache,target=/go/pkg/mod,uid=${USER_ID},gid=${GROUP_ID} \
    --mount=type=cache,target=/root/.cache/go-build,uid=${USER_ID},gid=${GROUP_ID} \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o main .

# ---------- Verify Build Artifacts ----------
RUN ls -la main && file main && echo "Build verified successfully"

# ---------- Build Stage Cleanup ----------
RUN rm -rf /tmp/* && \
    go clean -cache -modcache

# ================================
# Stage 4: Production Stage (Non-Root)
# ================================
FROM alpine:latest AS production

# ---------- Metadata Labels ----------
LABEL maintainer="farajassulai@gmail.com" \
    org.label-schema.name="goapp" \
    org.label-schema.description="Go application (non-root)" \
    org.label-schema.version="1.0.0" \
    org.label-schema.schema-version="1.0" \
    stage="production"

# ---------- Production Arguments ----------
ARG APP_NAME="goapp"
ARG APP_VERSION="1.0.0"
ARG APP_PORT=8080
ARG HEALTH_CHECK_PATH="/health"
ARG TIMEZONE="UTC"
ARG DATA_DIR="/var/lib/goapp"
ARG LOGS_DIR="/var/log/goapp"
ARG CONFIG_DIR="/etc/goapp"
ARG USER_ID=1001
ARG USER_NAME="gouser"
ARG GROUP_ID=1001
ARG GROUP_NAME="gogroup"

# ---------- Production Environment Variables ----------
ENV APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    APP_PORT=${APP_PORT} \
    HEALTH_CHECK_PATH=${HEALTH_CHECK_PATH} \
    TZ=${TIMEZONE} \
    DATA_DIR=${DATA_DIR} \
    LOGS_DIR=${LOGS_DIR} \
    CONFIG_DIR=${CONFIG_DIR} \
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
RUN mkdir -p ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR} /app && \
    chown -R ${USER_NAME}:${GROUP_NAME} ${DATA_DIR} ${LOGS_DIR} ${CONFIG_DIR} /app

# ---------- Set Working Directory ----------
WORKDIR /app

# ---------- Copy Build Artifacts from Build Stage ----------
COPY --from=build --chown=${USER_NAME}:${GROUP_NAME} /app/main ./

# ---------- Ensure Binary is Executable ----------
RUN chmod +x ./main

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

# ---------- Default Command ----------
CMD ["./main"]