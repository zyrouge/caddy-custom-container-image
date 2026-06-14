#!/bin/sh

set -eu

ROOT_DIR="$(dirname "$(realpath "$0")")"

. "$ROOT_DIR/_utils.sh"

get_release_info_key() {
    if ! [ -f "$DIST_DIR/$1" ]; then
        "$ROOT_DIR/release-info.sh"
    fi
    cat "$DIST_DIR/$1"
}

echo "Fetching version..."
if [ -z "${CADDY_VERSION:-}" ]; then
    CADDY_VERSION="$(get_release_info_key version.txt)"
fi

CREATED=$(date -u +"%Y-%m-%dT%H:%M:%S%z")

echo "Removing old image..."
podman rmi "$LOCAL_IMAGE_NAME:$CADDY_VERSION" > /dev/null 2>&1 || true

echo "Removing old manifest..."
podman manifest rm "$LOCAL_IMAGE_NAME:$CADDY_VERSION" > /dev/null 2>&1 || true

echo "Creating manifest..."
podman manifest create "$LOCAL_IMAGE_NAME:$CADDY_VERSION"

echo "Building image..."
podman build \
    --build-arg CREATED="$CREATED" \
    --build-arg CADDY_IMAGE_NAME="$CADDY_IMAGE_NAME" \
    --build-arg CADDY_IMAGE_TAG="$CADDY_VERSION-alpine" \
    --build-arg CADDY_BUILDER_IMAGE_NAME="$CADDY_BUILDER_IMAGE_NAME" \
    --build-arg CADDY_BUILDER_IMAGE_TAG="$CADDY_BUILDER_IMAGE_TAG" \
    --build-arg CADDY_VERSION="$CADDY_VERSION" \
    --platform linux/amd64 \
    --manifest "$LOCAL_IMAGE_NAME:$CADDY_VERSION" \
    "$ROOT_DIR"
echo "Built image $LOCAL_IMAGE_NAME:$CADDY_VERSION"
