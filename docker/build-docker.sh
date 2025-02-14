#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

DOCKER_IMAGE=${DOCKER_IMAGE:-bitcoingempay/bitcoingemd-develop}
DOCKER_TAG=${DOCKER_TAG:-latest}

BUILD_DIR=${BUILD_DIR:-.}

rm docker/bin/*
mkdir docker/bin
cp $BUILD_DIR/src/bitcoingemd docker/bin/
cp $BUILD_DIR/src/bitcoingem-cli docker/bin/
cp $BUILD_DIR/src/bitcoingem-tx docker/bin/
strip docker/bin/bitcoingemd
strip docker/bin/bitcoingem-cli
strip docker/bin/bitcoingem-tx

docker build --pull -t $DOCKER_IMAGE:$DOCKER_TAG -f docker/Dockerfile docker
