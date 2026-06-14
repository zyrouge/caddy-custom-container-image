# caddy-custom-container-image

Container image for Caddy with Cloudflare DNS plugin.

```bash
podman pull ghcr.io/zyrouge/caddy-custom:latest

podman run --rm \
    -p 8080:80 \
    -p 8443:443 \
    ghcr.io/zyrouge/caddy-custom:latest
```

# License

[Unlicense](./LICENSE)
