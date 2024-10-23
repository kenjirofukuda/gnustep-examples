#!/usr/bin/env bash

ensure_repo () {
  local owner=$1
  local repo=$2
  local my_base="${HOME}/Documents/github/${owner}"
  local my_repo="${my_base}/${repo}"
  local remote_repo="https://github.com/${owner}/${repo}.git"
  local debug="echo"
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

# swiftlang
ensure_repo "swiftlangs" "swift-corelibs-libdispatch"

# gnustep
ensure_repo "gnustep" "tools-make"
ensure_repo "gnustep" "libobjc2"
ensure_repo "gnustep" "libs-base"
ensure_repo "gnustep" "libs-gui"
ensure_repo "gnustep" "libs-back"

# trunkmaster
ensure_repo "trunkmaster" "nextspace"

# onflapp
ensure_repo "onflapp" "gs-desktop"
