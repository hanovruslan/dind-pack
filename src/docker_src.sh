#!/usr/bin/env bash

function dp_docker_run_cmd {
  local dict;
  local options;
  declare -A dict=(
    [v]=volumes
    [i]=image
    [c]=container
  )
  options=$(get_options ${@} "$(declare -p dict)")
  eval "declare -A options=${options#*=}"
  if [ -z ${options[image]} ]; then
    image=${DIND_PACK_IMAGE}
  else
    eval "declare -A image=${options[image]}"
    image=${image[0]}
  fi
  if [ -z ${options[container]} ]; then
    container=${image}
  else
    eval "declare -A container=${options[container]}"
    container=${container[0]}
  fi
  dp_docker_run_cmd=$(printf "docker run\n%4s-d\n%4s--name %s" "" "" "${container}")
  if [ -n "${options[volumes]}" ]; then
    eval "declare -A volumes=${options[volumes]}"
    for from in ${!volumes[@]}
    do
      dp_docker_run_cmd=$(printf "${dp_docker_run_cmd}\n%4s-v %s:%s" "" "${from}" "${volumes[${from}]}")
    done
  fi
  dp_docker_run_cmd=$(printf "${dp_docker_run_cmd}\n%4s%s" "" "${image}")

  echo ${dp_docker_run_cmd}
}
