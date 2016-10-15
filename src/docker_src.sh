#!/usr/bin/env bash

function dp_docker_run_cmd {
  local dict;
  local options;
  local res_fmt='docker run\n%4s--privileged\n%4s-d\n%4s--name %s'
  local res_fmt_vl='\n%4s-v %s:%s'
  local res_fmt_im='\n%4s%s'

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
  res=$(printf $"${res_fmt}" "" "" "" "${container}")
  if [ -n "${options[volumes]}" ]; then
    eval "declare -A volumes=${options[volumes]}"
    for host in ${!volumes[@]}
    do
      guest=${volumes[${host}]}
      host=$([ "${host}" -eq "${host}" ] 2>>/dev/null && echo ${volumes[${host}]} || echo ${host})
      res=$(printf $"${res}${res_fmt_vl}" "" "${host}" "${guest}")
    done
  fi
  res=$(printf $"${res}${res_fmt_im}" "" "${image}")

  echo "${res}"
}

function dp_docker_build_cmd {
  local dict;
  local options;
  local res_fmt='docker build\n%4s-t %s\n%4s--build-arg WORKDIR=%s\n%4s%s'

  declare -A dict=(
    [n]=name
    [p]=path
    [w]=workdir
  )
  options=$(get_options ${@} "$(declare -p dict)")
  eval "declare -A options=${options#*=}"
  if [ -z ${options[path]} ]; then
    path=${PWD}
  else
    eval "declare -A path=${options[path]}"
    path=${path[0]}
  fi
  if [ -z ${options[name]} ]; then
    name=${DIND_PACK_IMAGE}
  else
    eval "declare -A name=${options[name]}"
    name=${name[0]}
  fi
  if [ -z ${options[workdir]} ]; then
    workdir=${DIND_PACK_WORKDIR}
  else
    eval "declare -A workdir=${options[workdir]}"
    workdir=${workdir[0]}
  fi
  res=$(printf $"${res_fmt}" "" "${name}" "" "${workdir}" "" "${path}")

  echo "${res}"
}
