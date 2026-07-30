# syntax = docker.mirror.hashicorp.services/docker/dockerfile:experimental
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# This is only used by ODR
FROM docker.mirror.hashicorp.services/busybox:stable-musl as busybox
RUN touch /tmp/.keep

#--------------------------------------------------------------------
# CRT image
#--------------------------------------------------------------------

FROM docker.mirror.hashicorp.services/alpine:3.17.0 as crt

ARG BIN_NAME
# NAME and PRODUCT_VERSION are the name of the software in releases.hashicorp.com
# and the version to download. Example: NAME=boundary PRODUCT_VERSION=1.2.3.
ARG NAME=derrick
ARG PRODUCT_VERSION
# TARGETARCH and TARGETOS are set automatically when --platform is provided.
ARG TARGETOS
ARG TARGETARCH

LABEL name="Derrick" \
      maintainer="Nomatron Derrick Team <derrick@nomatron.io>" \
      vendor="Nomatron" \
      version=$PRODUCT_VERSION \
      release=$PRODUCT_VERSION


# git is for gitrefpretty() and other calls for Derrick
RUN apk add --no-cache git

COPY derrick /usr/bin/derrick
COPY derrick-entrypoint /usr/bin/derrick-entrypoint

VOLUME ["/data"]

# NOTE: userid must be 100 here. Otherwise upgrades will fail due to user not
# having the proper permissions to read the server db due to a different userid
RUN addgroup derrick && \
    adduser -S -u 100 -G derrick derrick && \
    mkdir /data/ && \
    chown -R derrick:derrick /data

# configure newuidmap/newgidmap to work with our derrick user
RUN mkdir -p /run/user/100 \
  && chown -R derrick /run/user/100 /home/derrick \
  && echo derrick:100000:65536 | tee /etc/subuid | tee /etc/subgid

USER derrick
ENV USER derrick
ENV HOME /home/derrick
ENV XDG_RUNTIME_DIR=/run/user/100
# Multiple builtin plugins register the same plugin.proto filename.
ENV GOLANG_PROTOBUF_REGISTRATION_CONFLICT=warn

ENTRYPOINT ["/usr/bin/derrick"]

#--------------------------------------------------------------------
# odr crt image
#--------------------------------------------------------------------
# This target is explicitly invoked from the command line, it's not used
# by the non-odr stages.
FROM gcr.io/kaniko-project/executor:v1.9.1 as odr-crt

ARG BIN_NAME
# NAME and PRODUCT_VERSION are the name of the software in releases.hashicorp.com
# and the version to download. Example: NAME=boundary PRODUCT_VERSION=1.2.3.
ARG NAME=derrick
ARG PRODUCT_VERSION
# TARGETARCH and TARGETOS are set automatically when --platform is provided.
ARG TARGETOS
ARG TARGETARCH

LABEL name="Derrick" \
      maintainer="Nomatron Derrick Team <derrick@nomatron.io>" \
      vendor="Nomatron" \
      version=$PRODUCT_VERSION \
      release=$PRODUCT_VERSION

COPY dist/$TARGETOS/$TARGETARCH/derrick /kaniko/derrick
COPY --from=busybox /bin/busybox /kaniko/busybox
COPY --from=busybox /tmp /kaniko/tmp

# We add busybox and populate it with the tool links to make the image
# easier to use (having a shell, basic tools, etc)
RUN ["/kaniko/busybox", "mkdir", "/kaniko/bin"]
RUN ["/kaniko/busybox", "--install", "-s", "/kaniko/bin"]

# Need to add the dir with our tools in PATH
ENV PATH $PATH:/kaniko/bin
ENV TMPDIR /kaniko/tmp
# Multiple builtin plugins register the same plugin.proto filename.
ENV GOLANG_PROTOBUF_REGISTRATION_CONFLICT=warn

ENTRYPOINT ["/kaniko/derrick"]
