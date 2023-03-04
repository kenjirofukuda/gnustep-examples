#!/bin/sh

ARGC=$#
if [ $ARGC -ne 1 ]; then
  echo "usage: disable_.sh {file}"
  exit 1
fi
FILE="$1"
if [ ! -f "$FILE" ]; then
  echo "not found: $FILE"
  exit 1
fi
CNT=$(grep -e  "OBJCFLAGS .* \-fobjc-arc" "$FILE" | wc -l)
if [ $CNT -eq 0 ]; then
  echo "already removed -fobjc-arc"
  exit 1
fi
sed -i -e 's/\(OBJCFLAGS += .*\)\(-fobjc-arc\)\(.*\)/\1 \3/g' "$FILE"
echo "success"
exit 0
