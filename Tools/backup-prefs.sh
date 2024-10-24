#!/usr/bin/env bash

reply=$(which gnustep-config)
if [ -z "$reply" ]; then
  echo "Sorry not a GNUstep environment."
  exit 1
fi
reply=$(gnustep-config --variable=GNUSTEP_USER_DEFAULTS_DIR)
fullpath=$(realpath "${HOME}/$reply")
OLD_CWD=$pwd
time_id=$(date +"%Y_%m_%d_%H_%M_%S")
basename="prefs-$(hostname)-${time_id}"
archive="/tmp/${basename}.zip"
cd "$fullpath"
rm -rf "$archive"
zip -q -r "$archive" . -i *.plist 
cd "$OLD_CWD"
