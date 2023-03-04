#!/bin/bash

target_dir="."

if [ $# -gt 0 ]; then
  target_dir="$1"
fi
echo "target_dir=${target_dir}"
if [ ! -d "$target_dir" ]; then
  echo "not found: $target_dir"
  exit 1
fi

# check for .ccls
target_file="$target_dir/.ccls"
if [ -f $target_file ]; then
  echo "file already exists: $target_file"
  exit 1
fi

db_file="$target_dir/compile_commands.json"
if [ -f "$db_file" ]; then
  echo "%compile_commands.json" > "$target_file"
  echo "%objective-c" >> "$target_file"
  echo "%objective-cpp" >> "$target_file"
  gnustep-config --objc-flags | tr ' ' "\n" >> "$target_file"
else
  echo "clang" > "$target_file"
  echo "%objective-c" >> "$target_file"
  echo "%objective-cpp" >> "$target_file"
  gnustep-config --objc-flags  | tr ' ' "\n" >> "$target_file"
fi

settings_file="$target_dir/.vscode/settings.json"
mkdir -p $(dirname "$settings_file")
if [ ! -f "$settings_file" ]; then
cat <<EOF > $settings_file
{
    "files.associations": {
        "*.h": "objective-c"
    },
}
EOF
fi

echo Success
exit 0
