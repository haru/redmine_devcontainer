#!/bin/sh
cd `dirname $0`

if [ -z "$1" ]
then
    echo "Usage: build.sh REDMINE_VERSION [RUBY_VERSION] [DEBIAN]" >&2
    exit 1
fi

REDMINE=$1

RUBY=3.2
if [ -n "$2" ]
then
  RUBY=$2
fi

DEBIAN=trixie
if [ -n "$3" ]
then
  DEBIAN=$3
fi

CONTAINER_VERSION="${REDMINE}-ruby${RUBY}"
docker buildx build --no-cache -t haru/redmine_devcontainer:${CONTAINER_VERSION} . \
    --build-arg RUBY_TAG=$RUBY_TAG \
    --build-arg REDMINE_VERSION=$REDMINE \
    --build-arg DEBIAN=$DEBIAN \
    --platform linux/amd64,linux/arm64/v8 \
    --output=type=image,push=true

#    --cache-from image:buildcache-arm64 --cache-from image:buildcache-amd64 \