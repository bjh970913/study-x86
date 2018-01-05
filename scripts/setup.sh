#!/usr/bin/env bash
CHDIR=$(pwd)
DIR=$(cd $(dirname "$0") && pwd)

TOOLS_DIR=$DIR"/../tools"
DIST_DIR=$DIR/../dist

mkdir $DIST_DIR 2>&-
cd $DIST_DIR
unzip -o $TOOLS_DIR/nasm*.zip 1>&-
rm -rf nasm && mv nasm-* nasm

VBoxManage import $TOOLS_DIR/*.ova --vsys 0 --vmname x86_study 1>&- 2>&-

export PATH=$DIR:$DIST_DIR/nasm:$PATH

cd $CHDIR
