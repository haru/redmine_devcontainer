#!/bin/sh
cd `dirname $0`

if [ -z "$1" ]
then
    echo "Usage: build.sh REDMINE_VERSION [RUBY_VERSION]" >&2
    exit 1
fi

REDMINE=$1

RUBY=3.2
if [ -n "$2" ]
then
  RUBY=$2
fi

CONTAINER_VERSION="${REDMINE}-ruby${RUBY}"
docker buildx build -t haru/redmine_devcontainer:${CONTAINER_VERSION} . \
    --cache-from image:buildcache-arm64 --cache-from image:buildcache-amd64 \
    --build-arg RUBY=$RUBY \
    --build-arg REDMINE_VERSION=$REDMINE \
    --platform linux/amd64,linux/arm64/v8 \
    --output=type=image,push=true