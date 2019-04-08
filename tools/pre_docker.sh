#!/usr/bin/env bash

DOCKER=$(which docker)
if [ "${DOCKER}" == "" ]; then
    echo "Package docker not found"
    exit 1
fi
if [ $(docker images -f "reference=study_x86_builder" -q | wc -l) -eq 0 ]; then
    pushd ${DOCKER_SRC}
        docker build --rm -t study_x86_builder .
    popd
fi