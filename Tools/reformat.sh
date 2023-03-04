#!/bin/bash
 
astyle_options="$(dirname $0)/_astyle_gnustep"
if [ ! -f "$astyle_options"; ]; then
  echo "not found: $astyle_options"
  exit 1
fi

target_dir="./"
if [ $# -gt 0 ]; then
  target_dir="$1"
  if [ ! -d "$target_dir" ]; then
    echo "not found: $target_dir"
    exit 1
  fi
fi

find "$target_dir" -type f \
       \( \
       -name "*.m" -or \
       -name "*.h" -or \
       -name "*.mm" -or \
       -name "*.c" -or \
       -name "*.cpp" \) -exec astyle {} "--options=${astyle_options}" --suffix=none \;
