#!/bin/bash
# Search Chef for roles not in-use

ARCHIVE=""

while getopts "a:" op; do
  case $op in
    a) ARCHIVE=$OPTARG ;;
  esac
done

if [ -n "$ARCHIVE" ]; then
  CR_CMD="cat $ARCHIVE"
else
  CR_CMD="knife role list"
fi
ROLES=$($CR_CMD)
CR_COUNT=$(echo $ROLES |wc -w |sed -e "s/\ //g")

echo "***** Processing $CR_COUNT roles in Chef org"
for role in $ROLES; do
  count=$(knife search node "roles:${role}" -i 2>/dev/null |wc -l |sed -e "s/\ //g")
  if [ $count -eq 0 ]; then
    echo "!! 0 associations = $role"
  fi
  sleep 5
done