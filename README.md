# caddy-custom-container-image

Container image for Caddy with Cloudflare DNS plugin.

```bash
podman pull ghcr.io/zyrouge/caddy:latest

podman run --rm \
    -p 8888:8888 \
    -v `pwd`/tinyproxy.conf:/etc/tinyproxy/tinyproxy.conf:ro \
    ghcr.io/zyrouge/tinyproxy:latest
```

# License

[Unlicense](./LICENSE)
