#!/usr/bin/env bash

my_echo () {
  echo $@
  eval $@
}


ensure_repo () {
  local owner=$1
  local repo=$2
  local my_base="${HOME}/Documents/github/${owner}"
  local my_repo="${my_base}/${repo}"
  local remote_repo="https://github.com/${owner}/${repo}.git"
  local debug="my_echo"
  "$debug" mkdir -p "$my_base"
  if [ -d "$my_repo" ]; then
    "$debug" cd "$my_repo"
    "$debug" git fetch
    local src=$(git branch | grep '^*' | awk '{print $NF}')
    local dst=$(git branch --remote | grep  'HEAD' | awk '{print $NF}')
    "$debug" git diff "$src" "$dst" 
  else
    "$debug" cd "$my_base"
    "$debug" git clone "$remote_repo"
  fi
  echo ""
}

# kenjirofukuda
ensure_repo "kenjirofukuda" "sandbox"
ensure_repo "kenjirofukuda" "libs-renaissance"
ensure_repo "kenjirofukuda" "gdsfeel-gnustep"

# swiftlang
ensure_repo "swiftlang" "swift-corelibs-libdispatch"

# gnustep
ensure_repo "gnustep" "tools-make"
ensure_repo "gnustep" "libobjc2"
ensure_repo "gnustep" "libs-base"
ensure_repo "gnustep" "libs-gui"
ensure_repo "gnustep" "libs-back"
ensure_repo "gnustep" "libs-renaissance"

# trunkmaster
ensure_repo "trunkmaster" "nextspace"

# onflapp
ensure_repo "onflapp" "gs-desktop"
