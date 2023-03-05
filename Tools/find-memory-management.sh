#!/bin/bash

s=0
while getopts h:m:s:v-: opt; do
  # OPTARG を = の位置で分割して opt と optarg に代入
  optarg="$OPTARG"
  if [[ "$opt" = - ]]; then
    opt="-${OPTARG%%=*}"
    optarg="${OPTARG/${OPTARG%%=*}/}"
    optarg="${optarg#=}"

    if [[ -z "$optarg" ]] && [[ ! "${!OPTIND}" = -* ]]; then
       optarg="${!OPTIND}"
       shift
    fi
  fi

  case "-$opt" in
    -h|--hour)
       h="$optarg"
       ;;
    -m|--minute)
       m="$optarg"
       ;;
    -s|--simple)
       s=1
       ;;
    -v|--version)
       echo 'v0.0.0'
       exit
       ;;
    --)
       break
       ;;
    -\?)
       exit 1
       ;;
    --*)
       echo "$0: illegal option -- ${opt##-}" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

target_dir="."

if [ $# -gt 0 ]; then
  target_dir="$1"
fi
# echo "target_dir=${target_dir}"
if [ ! -d "$target_dir" ]; then
  echo "not found: $target_dir"
  exit 1
fi


pat_strict='\[\s*.+\s+(retain|release|autorelease|dealloc|destroy|drain)\s*\]'
pat_simple='\s*(retain|release|autorelease|dealloc|destroy|drain)\s*\]'
pat="$pat_strict"
if [ $s -eq 1 ]; then
  pat="$pat_simple"
fi

sources=/tmp/sources_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -nH -E "$pat" {} \; | grep -v "@" > $sources

cat $sources
exit 0
