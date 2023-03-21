#!/bin/bash
 
astyle_options="$(dirname $0)/_astyle_gnustep"
script="$(dirname $0)/post_reformat.awk"

if [ ! -f "$astyle_options" ]; then
  echo "not found: $astyle_options"
  exit 1
fi

if [ ! -f "$script" ]; then
  echo "not found: $script"
  exit 1
fi

path=""
if [ $# -eq 0 ]; then
  echo "require source path"
  exit 1
fi

path="$1"
if [ ! -f "$path" ]; then
  echo "not found: $path"
  exit 1
fi

tmp="/tmp/$(echo `realpath $path` | sed -e 's/\//@/g' )"
astyle "--options=${astyle_options}" < "$path" | awk -f "$script" > "$tmp"
cp "$tmp" "$path" && rm "$tmp"
