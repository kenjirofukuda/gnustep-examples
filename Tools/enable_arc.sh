#!/bin/bash

target_dir="."

if [ $# -gt 0 ]; then
  target_dir="$1"
fi
# echo "target_dir=${target_dir}"
if [ ! -d "$target_dir" ]; then
  echo "not found: $target_dir"
  exit 1
fi

find "$target_dir" -type f \( -name "GNUmakefile" -or -name "GNUmakefile.*" \) \
  -exec "$(dirname $0)/_enable_arc.sh" {} \;
