ARG IMAGE_NAME=caddy-custom-container-image
ARG MAINTAINER=hello@zyrouge.me
ARG CREATED=01-01-01T00:00:00Z

ARG CADDY_IMAGE_NAME=docker.io/library/caddy
ARG CADDY_IMAGE_TAG=alpine
ARG CADDY_VERSION=0.0.0

ARG CADDY_BUILDER_IMAGE_NAME=docker.io/library/caddy
ARG CADDY_BUILDER_IMAGE_TAG=builder-alpine

FROM $CADDY_BUILDER_IMAGE_NAME:$CADDY_BUILDER_IMAGE_TAG as builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM $CADDY_IMAGE_NAME:$CADDY_IMAGE_TAG

LABEL maintainer="$MAINTAINER"
LABEL org.opencontainers.image.name="$IMAGE_NAME"
LABEL org.opencontainers.image.created="$CREATED"
LABEL org.opencontainers.image.version="$CADDY_VERSION"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
