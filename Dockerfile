#
# Dockerfile for pre-commit-hooks
#

FROM hadolint/hadolint:2.6.0 as build-hadolint

FROM hadenlabs/build-tools:0.1.0 as base

ENV PATH $PATH:/go/bin:/usr/local/go/bin:/root/.local/bin:/usr/bin

ENV BASE_DEPS \
    bash

ENV BUILD_DEPS \
    curl \
    gnupg \
    openssl

FROM golang:1.16.4 as go-builder

ENV BUILD_DEPS \
    gcc \
    openssl

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    $BUILD_DEPS \
    && go get -u -v github.com/zricethezav/gitleaks/v7


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

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    $BUILD_DEPS \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    $BASE_DEPS \
    $PERSIST_DEPS \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    # Install modules python
    && python -m pip install --user --no-cache-dir $MODULES_PYTHON \
    # Install modules node
    && yarn global add $MODULES_NODE \
    && sed -i "s/root:\/root:\/bin\/ash/root:\/root:\/bin\/bash/g" /etc/passwd \
    && apt-get clean \
    && apt-get purge -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# go
COPY --from=go-builder /go/bin/* /go/bin/

# hadolint
COPY --from=build-hadolint /bin/hadolint /usr/local/bin/

# Reset the work dir
WORKDIR /data

CMD ["/bin/bash"]