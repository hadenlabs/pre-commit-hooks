#
# Dockerfile for pre-commit-hooks
#

FROM golangci/golangci-lint:v1.41.1 as golangci-lint-base

FROM hadolint/hadolint:2.6.0 as hadolint-base

FROM hadenlabs/build-tools:0.1.0 as base

ENV GOPATH /go
ENV GOROOT /usr/local/go

ENV PATH $PATH:/go/bin:/usr/local/go/bin:/root/.local/bin:/usr/bin

ENV BASE_DEPS \
    build-essential \
    bash

ENV PERSIST_DEPS \
    upx

ENV BUILD_DEPS \
    gcc \
    curl \
    gnupg \
    openssl

FROM golang:1.16.4 as go-base

ENV GOPATH /go
ENV GOROOT /usr/local/go

ENV GO111MODULE on
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV LANG en_US.UTF-8
ENV GOFLAGS "-ldflags=-w -ldflags=-s"

ENV BUILD_DEPS \
    gcc \
    openssl

ENV PERSIST_DEPS \
    upx

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    $BUILD_DEPS \
    $PERSIST_DEPS \
    && apt-get clean \
    && apt-get purge -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM go-base AS gotests

RUN GO111MODULE=on go get -u  \
    --ldflags -s -w --trimpath \
    github.com/cweill/gotests/gotests \
    && upx -9 "${GOPATH}"/bin/gotests

FROM go-base AS gitleaks

RUN GO111MODULE=on go get -u  \
    --ldflags "-s -w" --trimpath \
    github.com/zricethezav/gitleaks/v7 \
    && upx -9 "${GOPATH}"/bin/gitleaks

FROM go-base AS goimports

RUN GO111MODULE=on go get -u  \
    --ldflags -s -w --trimpath \
    golang.org/x/tools/cmd/goimports \
    && upx -9 "${GOPATH}"/bin/goimports

FROM go-base AS goimports-update-ignore

RUN GO111MODULE=on go get -u  \
    --ldflags -s -w --trimpath \
    github.com/pwaller/goimports-update-ignore \
    && upx -9 "${GOPATH}"/bin/goimports-update-ignore

FROM go-base AS go

RUN upx -9 "${GOROOT}"/bin/*

FROM base as go-bins

COPY --from=golangci-lint-base /usr/bin/golangci-lint $GOPATH/bin/golangci-lint

COPY --from=gitleaks $GOPATH/bin/gitleaks $GOPATH/bin/gitleaks
COPY --from=goimports $GOPATH/bin/goimports $GOPATH/bin/goimports
COPY --from=goimports-update-ignore $GOPATH/bin/goimports-update-ignore $GOPATH/bin/goimports-update-ignore
COPY --from=gotests $GOPATH/bin/gotests $GOPATH/bin/gotests

FROM base as crossref

ENV BUILD_DEPS \
    curl \
    gnupg \
    openssl

ENV PERSIST_DEPS \
    nodejs \
    yarn \
    git

ENV MODULES_PYTHON \
    pre-commit \
    docker-compose

ENV MODULES_NODE \
    markdown-link-check

ENV PATH $PATH:/go/bin:/usr/local/go/bin:/root/.local/bin:/usr/bin:/usr/local/bin

ENV GOPATH /go

ENV GOROOT /usr/local/go

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    "$BUILD_DEPS" \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    "${BASE_DEPS}" \
    "${PERSIST_DEPS}" \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    # Install modules python
    && python -m pip install --user --no-cache-dir "${MODULES_PYTHON}" \
    # Install modules node
    && yarn global add "${MODULES_NODE}" \
    && sed -i "s/root:\/root:\/bin\/ash/root:\/root:\/bin\/bash/g" /etc/passwd \
    && apt-get clean \
    && apt-get purge -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=go $GOROOT/bin $GOROOT/bin
COPY --from=go $GOROOT/src $GOROOT/src
COPY --from=go $GOROOT/lib $GOROOT/lib
COPY --from=go $GOROOT/pkg $GOROOT/pkg
COPY --from=go $GOROOT/misc $GOROOT/misc
COPY --from=go-bins $GOPATH/bin $GOPATH/bin

# hadolint
COPY --from=hadolint-base /bin/hadolint /usr/local/bin/

# Reset the work dir
WORKDIR /data

CMD ["/bin/bash"]