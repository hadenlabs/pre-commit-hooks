#
# Dockerfile for pre-commit-hooks
#

FROM hairyhenderson/gomplate:v3.9.0 as gomplate
FROM golangci/golangci-lint:v1.39.0 as golangci-lint
FROM alpine/terragrunt:0.15.0 as hashicorp

FROM golang:1.16.3-alpine3.13 as base

ENV BASE_DEPS \
    alpine-sdk \
    bash \
    build-base

ENV BUILD_DEPS \
    fakeroot \
    freetype-dev \
    curl \
    openssl \
    gcc

ENV PERSIST_DEPS \
    git \
    py3-pip \
    python3 \
    python3-dev \
    make \
    shellcheck

ENV MODULES_PYTHON \
    checkov \
    pre-commit


FROM base as go-builder

ENV BUILD_DEPS \
    fakeroot \
    freetype-dev \
    gcc \
    git \
    make \
    musl-dev \
    openrc \
    openssl

RUN apk --no-cache add \
    $BASE_DEPS \
    $BUILD_DEPS \
    && go get -u -v golang.org/x/tools/cmd/goimports \
    && go get -u -v github.com/BurntSushi/toml/cmd/tomlv \
    && go get -u -v github.com/preslavmihaylov/todocheck \
    && go get -u -v golang.org/x/lint/golint \
    && go get -u -v github.com/fzipp/gocyclo/cmd/gocyclo \
    && go get -u -v github.com/go-critic/go-critic/cmd/gocritic

FROM node:14.16.1-alpine3.13 as node

ENV BASE_DEPS \
    alpine-sdk \
    bash \
    build-base

ENV MODULES_NODE \
    markdown-link-check

RUN apk add --no-cache \
    $BASE_DEPS \
    # Install modules node
    && yarn global add $MODULES_NODE

FROM base as crossref

RUN apk add --no-cache \
    $BASE_DEPS \
    $PERSIST_DEPS \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    # Install modules python
    && python3 -m pip install --user --upgrade --no-cache-dir $MODULES_PYTHON \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && sed -i "s/root:\/root:\/bin\/ash/root:\/root:\/bin\/bash/g" /etc/passwd

# node
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/bin/yarn /usr/local/bin/yarn
COPY --from=node /usr/local/bin/markdown-link-check /usr/local/bin/markdown-link-check

# go

COPY --from=go-builder /go/bin/* /usr/local/bin/
COPY --from=gomplate /gomplate /usr/local/bin/gomplate
COPY --from=golangci-lint /usr/bin/golangci-lint /usr/local/bin/golangci-lint

# terraform

COPY --from=hashicorp /bin/terraform /usr/local/bin/
COPY --from=hashicorp /usr/local/bin/terragrunt /usr/local/bin/

# Reset the work dir
WORKDIR /app

CMD ["/bin/bash"]