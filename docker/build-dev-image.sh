#!/bin/bash -e

CONTAINER=cpp_docker_env

if /usr/bin/docker ps | grep "${CONTAINER}" > /dev/null; then
  docker-compose down
fi

DOCKER_BUILDKIT=1 docker -l debug build \
    --target cpp-docker-dev \
    --build-arg DEV_USER=dev \
    -t cppdevenv:latest .
