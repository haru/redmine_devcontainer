#!/bin/sh

docker buildx build -t haru/redmine_devcontainer . --platform linux/amd64,linux/arm64/v8 \
    --output=type=image,push=true