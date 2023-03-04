#!/bin/bash

print_key() {
  local key="$1"
  local value=$(gnustep-config --variable=${key})
  if [[ $value = /* ]]; then
    if [ !  -e $value ]; then
      value="~~${value}~~"
    fi
  fi
  echo "|${key}|${value}|"
}

key_gen() {
  for each2 in SYSTEM NETWORK LOCAL USER 
  do
    echo $each2	  
    for each1 in APPS TOOLS LIBRARY HEADERS LIBRARIES DOC DOC_MAN DOC_INFO
    do
      echo "GNUSTEP_${each2}_${each1}"
    done
  done
}

print_pre() {
  echo "\`\`\`"
}

print_flags() {
  local flag=$1
  echo "## $flag"
  echo ""
  print_pre
  gnustep-config $flag | tr ' ' "\n"
  print_pre
  echo ""
}

echo ""
echo "# GNUstep config"
echo "## Variables"
echo ""
echo "|   |   |"
echo "|---|---|"
for key in CC CXX OBJCXX LDFLAGS EXEEXT DEBUGGER GNUMAKE GNUSTEP_MAKEFILES GNUSTEP_USER_DEFAULTS_DIR GNUSTEP_HOST GNUSTEP_HOST_CPU GNUSTEP_HOST_VENDER GNUSTEP_HOST_OS GNUSTEP_IS_FLATTEND
do
  print_key "$key"
done

echo ""
echo "## Domains paths"
for key in $(key_gen)
do
  if [[ $key = GNUSTEP* ]]; then
    print_key "$key"
  else
    echo "### Doamin($key)"
    echo ""
    echo "|   |   |"
    echo "|---|---|"
  fi	
done

print_flags "--debug-flags"
print_flags "--objc-flags"
print_flags "--objc-libs"
print_flags "--base-libs"
print_flags "--gui-libs"
print_flags "--host-dir"
print_flags "--host-ldir"

for domain in SYSTEM NETWORK LOCAL USER 
do
  print_flags "--installation-domain-for=${domain}"
  print_flags "--target-dir-for=${domain}"
  print_flags "--target-ldir-for=${domain}"
done
