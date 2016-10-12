#!/usr/bin/env bash

self_dir=$(dirname $(readlink -f "$0"))

source ${self_dir}/../env/main.env

name=${1:-${DIND_PACK_IMAGE}}
workdir=${2:-${DIND_PACK_WORKDIR}}
path=$(dirname $(readlink -f "$0"))

docker build \
  -t ${name} \
  --build-arg WORKDIR=${workdir} \
  ${path}
