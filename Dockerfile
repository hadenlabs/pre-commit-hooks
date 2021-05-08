#
# Dockerfile for pre-commit-hooks
#

FROM hadenlabs/build-tools:latest as base

ENV PATH $PATH:/root/.local/bin

ENV BASE_DEPS \
    alpine-sdk \
    bash

ENV BUILD_DEPS \
    build-base \
    fakeroot \
    curl \
    openssl

ENV PERSIST_DEPS \
    git

FROM base as go-builder

RUN apk --no-cache add \
    $BASE_DEPS \
    $BUILD_DEPS \
    && go get -u -v github.com/zricethezav/gitleaks/v7

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

FROM python:3.8-alpine3.13 as python-builder

ENV PERSIST_DEPS \
    py3-pip \
    python3 \
    python3-dev

ENV MODULES_PYTHON \
    pre-commit

ENV BUILD_DEPS \
    build-base \
    fakeroot \
    curl \
    openssl

RUN apk add --no-cache \
    $PERSIST_DEPS \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    # Install modules python
    && python -m pip install --user --upgrade --no-cache-dir $MODULES_PYTHON \
    && sed -i "s/root:\/root:\/bin\/ash/root:\/root:\/bin\/bash/g" /etc/passwd \
    && apk del .build-deps \
    && rm -rf /root/.cache \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

FROM base as crossref

RUN apk add --no-cache \
    $BASE_DEPS \
    $PERSIST_DEPS \
    && apk add --no-cache --virtual .build-deps $BUILD_DEPS \
    && sed -i "s/root:\/root:\/bin\/ash/root:\/root:\/bin\/bash/g" /etc/passwd \
    && apk del .build-deps \
    && rm -rf /root/.cache \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# node
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/bin/yarn /usr/local/bin/yarn
COPY --from=node /usr/local/bin/markdown-link-check /usr/local/bin/markdown-link-check

# python
COPY --from=python-builder /usr/bin/python /usr/bin/
COPY --from=python-builder /usr/bin/pip /usr/bin/
COPY --from=python-builder /root/.local/bin/pre-commit /usr/local/bin/

# go
COPY --from=go-builder /go/bin/* /usr/local/bin/

# Reset the work dir
WORKDIR /data

CMD ["/bin/bash"]