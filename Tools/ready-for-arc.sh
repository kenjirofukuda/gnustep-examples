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
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -l -E '\[\s*super\s+dealloc\s*\]' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E 's/\[\s*super\s+dealloc\s*\]/DEALLOC/' "$path"
done
rm -rf $sources


# retain
sources=/tmp/sources_retain_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -l -E '\[\s*.+\s+retain\s*\]' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E 's/\[\s*(.+)\s+retain\s*\]/RETAIN(\1)/g' "$path"
done
rm -rf $sources


# autorelease
sources=/tmp/sources_autorelease_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -l -E '\[\s*.+\s+autorelease\s*\]' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E 's/\[\s*(.+)\s+autorelease\s*\]/AUTORELEASE(\1)/g' "$path"
done
rm -rf $sources


# release
sources=/tmp/sources_release_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -l -E '\[\s*.+\s+release\s*\]' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E 's/\[\s*(.+)\s+release\s*\]/RELEASE(\1)/g' "$path"
done
rm -rf $sources


# drain
sources=/tmp/sources_drain_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -l -E '\[\s*.+\s+drain\s*\]' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E 's/\[\s*(.+)\s+drain\s*\]/DRAIN(\1)/g' "$path"
done
rm -rf $sources


# illigal dealloc
sources=/tmp/sources_ill_dealloc_$$.txt
find "$target_dir" -type f \( -name "*.m" -or -name "*.mm" \) \
  -exec grep -l -E '\[\s*.+\s+dealloc\s*\]\s*;' {} \; | grep -v "@" > $sources

for path in $(cat $sources)
do
  echo "==> $path"
  sed -i -E 's/\[\s*(.+)\s+dealloc\s*\]\s*;/RELAESE(\1); \/\/ dealloc -> RELEASE/g' "$path"
done
rm -rf $sources


