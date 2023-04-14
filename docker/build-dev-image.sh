#!/bin/bash -e

DOCKER_BUILDKIT=1 docker -l debug build \
    --target cpp-docker-dev \
    --build-arg DEV_USER=dev \
    -t cpp_dev_env:latest .
