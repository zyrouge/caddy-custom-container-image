#!/bin/sh

set -eu

ROOT_DIR="$(dirname "$(realpath "$0")")"

. "$ROOT_DIR/_utils.sh"

mkdir -p "$DIST_DIR"

if [ -z "${CADDY_VERSION:-}" ]; then
    podman pull "$CADDY_IMAGE_NAME:$CADDY_IMAGE_TAG"
    CADDY_VERSION="$(podman inspect --format '{{ index .Config.Labels "org.opencontainers.image.version" }}' "$CADDY_IMAGE_NAME:$CADDY_IMAGE_TAG")"
    CADDY_VERSION="${CADDY_VERSION#v}"
    if [ "$?" -ne 0 ] || [ -z "$CADDY_VERSION" ]; then
        echo "Error: Failed to fetch caddy version"
        exit 1
    fi
fi

echo "Version: $CADDY_VERSION"
echo "$CADDY_VERSION" > "$DIST_DIR/version.txt"

if [ -z "${NEEDS_RELEASE:-}" ]; then
    set +e
    IMAGE_MANIFEST=$(podman manifest inspect "$IMAGE_NAME:$CADDY_VERSION" 2>&1)
    FOUND_VERSION_EXIT_CODE="$?"
    set -e
    if [ "$FOUND_VERSION_EXIT_CODE" -eq 0 ]; then
        NEEDS_RELEASE="false"
    elif [ "$FOUND_VERSION_EXIT_CODE" -eq 125 ]; then
        NEEDS_RELEASE="true"
    else
        echo "$IMAGE_MANIFEST"
        echo "Error: Failed to fetch image manifest"
        exit 1
    fi
fi

echo "Needs release: $NEEDS_RELEASE"
echo "$NEEDS_RELEASE" > "$DIST_DIR/needs_release.txt"
