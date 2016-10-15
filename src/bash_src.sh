#!/usr/bin/env bash

# extract values from options and return it as 2d assiciative array of values
# works only with short options for now
#
# example:
#   dict = {x: var_y, y: var_y, z: 'array_var_z'}
#   for options '-x 1 -y 2 -z a:b -z y:x'
#   will return
#   {var_x: [1], var_y: [2], array_var_z: {a: b, y: x}}
#
# please fill free to debug this function and dp_docker_run_cmd as well in order to unveil details
function get_options {
  local dict=${@: -1};
  local result;
  local sep_val=${DIND_OPT_SEP}
  local sep_case='|'
  local opt_pat;
  local opt_case=();
  local reg=();
  local cnt;

  declare -A cnt=()
  declare -A result=()

  eval "declare -A dict="${dict#*=}
  for key in ${!dict[@]}
  do
    opt_pat=${opt_pat}${key}${sep_val}
    opt_case+=(${key})
  done
  opt_case=$(printf "${sep_case}%s" "${opt_case[@]}")
  opt_case='@('${opt_case:${#sep_case}}')'

  # `shopt -s extglob` enable var substitution in the case "${opt_case})"
  shopt -q extglob; extglob_set=$?
  ((extglob_set)) && shopt -s extglob
  while getopts ${opt_pat} opt_value
  do
    case $opt_value in
      ${opt_case})
      optarg=(${OPTARG//${sep_val}/ })
      var=${dict[${opt_value}]}
      key=${optarg[0]}
      value=${optarg[1]:-${key}}
      if [ -z "${!var}" ]; then
        reg+=(${var})
        cnt+=([${var}]=0)
      fi
      _value=$( [ "${key}" == "${value}" ] && echo [${cnt[${var}]}]=${value} || echo [${key}]=${value} )
      cnt[${var}]=$(( ${cnt[${var}]}+1 ));
      eval "${var}=${!var:-${sep_val}}${_value}${sep_val}"
      ;; *)
         echo 'Unknown options'
         exit 1
      ;;
    esac
  done
  for key in ${reg[@]}
  do
    value=$(echo ${!key}|sed "s/^\\${sep_val}//;s/\\${sep_val}$//")
    value=(${value//:/ })
    result[${key}]="(${value[@]})"
  done
  # revert back to previous value
  ((extglob_set)) && shopt -u extglob

  declare -p result
}
