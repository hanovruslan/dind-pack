#!/usr/bin/env bash

self_dir=$(dirname $(readlink -f $0))

source ${self_dir}/../env/main.env
source ${self_dir}/../src/docker_src.sh
source ${self_dir}/../src/bash_src.sh

run_cmd=$(dp_docker_run_cmd ${@})
${run_cmd}
