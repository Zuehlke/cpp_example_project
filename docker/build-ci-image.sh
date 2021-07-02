#!/bin/bash -e

DOCKER_BUILDKIT=1 docker -l debug build \
    --target cpp-docker-ci \
    -t cppcienv:latest .
