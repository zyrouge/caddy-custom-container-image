#!/bin/sh

set -eu

if [ -z "${ROOT_DIR:-}" ]; then
    exit 67
fi

DIST_DIR="$ROOT_DIR/dist"

GIT_URL="https://github.com/zyrouge/caddy-custom-container-image.git"
IMAGE_NAME="ghcr.io/zyrouge/caddy-custom"
LOCAL_IMAGE_NAME="localhost/caddy-custom"

CADDY_IMAGE_NAME="docker.io/library/caddy"
CADDY_IMAGE_TAG="alpine"

CADDY_BUILDER_IMAGE_NAME="docker.io/library/caddy"
CADDY_BUILDER_IMAGE_TAG="builder-alpine"
