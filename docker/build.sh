#!/usr/bin/env bash

self_dir=$(dirname $(readlink -f ${0}))

source ${self_dir}/../env/main.env
source ${self_dir}/../src/docker_src.sh
source ${self_dir}/../src/bash_src.sh

docker_cmd=$(dp_docker_build_cmd ${@})
if [ ${DIND_PACK_DEBUG} = true ]; then
  echo "${docker_cmd}"
else
  ${docker_cmd}
fi
