#!/bin/bash
grep -v -e '^#' u2204-prerequires.txt \
    | grep -v -e '^$' \
    | sed 's/^/sudo apt-get install /g' \
    | sh
