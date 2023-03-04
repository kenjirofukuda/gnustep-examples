#!/bin/sh

ARGC=$#
if [ $ARGC -ne 1 ]; then
  echo "usage: enable_arc.sh {file}"
  exit 1
fi
FILE="$1"
if [ ! -f "$FILE" ]; then
  echo "not found: $FILE"
  exit 1
fi
CNT=$(grep -e  "OBJCFLAGS .* \-fobjc-arc" "$FILE" | wc -l)
if [ $CNT -ge 1 ]; then
  echo "already specify -fobjc-arc"
  exit 1
fi
sed -i 's/\s*$//' "$FILE"
sed -i -e 's/OBJCFLAGS += \(.*\)$/& -fobjc-arc/g' "$FILE" 
echo "success"
exit 0
