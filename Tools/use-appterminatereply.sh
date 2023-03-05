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

# super dealloc
sources=/tmp/sources_dealloc_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" -or -name "*.h"  \) \
  -exec grep -l -E '\-\s*\(BOOL\)\s*applicationShouldTerminate:' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E  's/(\-\s*)(\(BOOL\))(\s*applicationShouldTerminate:)/\1(NSApplicationTerminateReply)\3/g' "$path"
done
rm -rf $sources
