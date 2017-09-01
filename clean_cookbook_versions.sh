#!/bin/bash
COOKBOOK=${1:-"chef-sample"}
KEEP=${2:-10}

i=1
for c in `knife cookbook show $COOKBOOK`; do
  if [ "$c" == "$COOKBOOK" ]; then
    continue
  else
    if [ $i -le $KEEP ]; then
      echo "Keeping $COOKBOOK version: $c"
    else
      knife cookbook delete $COOKBOOK $c -y
    fi
    i=$((i+1))
  fi
done