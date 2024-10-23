#!/usr/bin/env bash
reply=$(which ip)
if [ -n "$reply" ]; then
  ip -4 -o address | grep 192.168 | awk '{print $4}' | awk -F/ '{print $1}'
  exit 0
fi
if [ -e /sbin/ifconfig ] ; then
  /sbin/ifconfig | grep 192.168 | awk '{print $2}'
  exit 0
fi
exit 1
