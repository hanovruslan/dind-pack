#!/usr/bin/env bash

self_path=$(readlink -f "$0")
self_dir=$(dirname ${self_path})

source ${self_dir}/../env/main.env

name=${1:-${DIND_PACK_IMAGE}}
path=$(dirname $(readlink -f "$0"))

docker build \
  -t ${name} \
  --build-arg WORKDIR=${DIND_PACK_WORKDIR} \
  ${path}
