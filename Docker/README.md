# Newman Docker Image

This folder builds a small custom image based on the Newman CLI image and adds common network utilities plus the CSV All-in-One reporter.

## Requirements

- Docker Engine
- A Postman collection (and environment file if your collection needs one)

## Build

Run from this directory:

```bash
docker build -t newman:local .
```

## Verify the image

```bash
docker run --rm newman:local --version
docker run --rm newman:local run --help
```

## Run a collection

Mount the collection into the container; do not bake API keys or environment secrets into the image:

```bash
docker run --rm \
  -v "$PWD:/etc/newman" \
  newman:local run collection.json
```

If the collection requires credentials, provide them through a protected environment file or CI secret mechanism. Never commit tokens, passwords, or private environment files.

## Notes

- The base image is pinned to the `5.3.1-alpine` tag in the Dockerfile. Review and update it deliberately when refreshing dependencies.
- The current build script is a convenience wrapper; this README documents commands that can be run directly from this folder.
