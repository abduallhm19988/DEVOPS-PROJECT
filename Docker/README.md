# Docker Image for Newman

This directory contains a Docker configuration to build a custom image based on `postman/newman:5.3.1-alpine`. The image is designed to run Newman, the command-line collection runner for Postman, with additional utilities installed for enhanced functionality.

## Structure

- **Dockerfile**: Defines the custom Docker image for running Newman.
- **build-and-run.sh**: A shell script to build and run the Docker image.

## Building the Image

To build the Docker image, you can use the following command:

```bash
docker build -t newman:v1 .
