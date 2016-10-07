#!/usr/bin/env bash

function get_options {
  local dict=${@: -1};
  local result;
  local sep_val=${DIND_OPT_SEP}
  local sep_case='|'
  local opt_pat;
  local opt_case=();
  local reg=();

  declare -A result=()

  eval "declare -A dict="${dict#*=}
  for key in ${!dict[@]}
  do
    opt_pat=${opt_pat}${key}${sep_val}
    opt_case+=(${key})
  done
  opt_case=$(printf "${sep_case}%s" "${opt_case[@]}")
  opt_case='@('${opt_case:${#sep_case}}')'

  # `shopt -s extglob` enable var substitution in the case
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
      fi
      _value=$( [ "${key}" == "${value}" ] && echo [0]=${value} || echo [${key}]=${value} )
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
