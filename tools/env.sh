#!/usr/bin/env bash

export VBOX_ENV_NAME="x86_study"
export SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
export ROOT_DIR=${SCRIPT_DIR}/..
export BUILD_DIR=${ROOT_DIR}/build
export BUILD_RESULT=${BUILD_DIR}/image.img
export TOOLS_DIR=${SCRIPT_DIR}/../tools
export TOOLS_OVA=${TOOLS_DIR}/x86_barebone.ova
export DOCKER_SRC=${ROOT_DIR}/docker

function require() {
    source ${SCRIPT_DIR}/$1
}
