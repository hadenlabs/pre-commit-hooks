#
# Dockerfile for pre-commit-hooks
#
FROM alpine:3.13.5 as base

ENV BASE_DEPS \
    alpine-sdk \
    bash \
    build-base

ENV PERSIST_DEPS \
    git \
    nodejs \
    yarn \
    py3-pip \
    python3 \
    python3-dev \
    shellcheck

ENV MODULES_PYTHON \
    checkov \
    pre-commit

env MODULES_NODE \
    markdown-link-check

FROM hairyhenderson/gomplate:v3.9.0 as gomplate
FROM golangci/golangci-lint:v1.39.0 as golangci-lint

FROM golang:1.16.3-alpine3.12 as go-builder

ENV BASE_DEPS \
    alpine-sdk \
    bash \
    build-base

ENV BUILD_DEPS \
    fakeroot \
    git \
    make \
    openrc \
    openssl

ENV PERSIST_DEPS \
    git \
    nodejs \
    yarn \
    py3-pip \
    python3 \
    python3-dev \
    shellcheck

RUN apk --no-cache add \
    $BASE_DEPS \
    $BUILD_DEPS \
    && go get -u -v golang.org/x/tools/cmd/goimports \
    && go get -u -v github.com/BurntSushi/toml/cmd/tomlv \
    && go get -u -v github.com/preslavmihaylov/todocheck \
    && go get -u -v golang.org/x/lint/golint

FROM base as cressref

RUN apk --no-cache add \
    $BASE_DEPS \
    $PERSIST_DEPS \
    # Install modules python
    && pip install --no-cache-dir $MODULES_PYTHON \
    # Install modules node
    && yarn global add $MODULES_NODE

COPY --from=go-builder /usr/local/bin/* /usr/local/bin/
COPY --from=gomplate /gomplate /usr/local/bin/gomplate
COPY --from=golangci-lint /usr/bin/golangci-lint /usr/local/bin/golangci-lint

# Reset the work dir
WORKDIR /app
