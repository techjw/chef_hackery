#!/bin/bash
# Search Chef for cookbooks with excessive version history

ARCHIVE=""
VCOUNT=20

while getopts "a:c:" op; do
  case $op in
    a) ARCHIVE=$OPTARG ;;
    c) VCOUNT=$OPTARG ;;
  esac
done

if [ -n "$ARCHIVE" ]; then
  CB_CMD="cat $ARCHIVE"
else
  CB_CMD="knife cookbook list"
fi
COOKBOOKS=$($CB_CMD |awk '{print $1}' |egrep -v '^.*_test$')
CB_COUNT=$(echo $COOKBOOKS 2>/dev/null|wc -w |sed -e "s/\ //g")

echo "***** Checking version counts for $CB_COUNT cookbooks in Chef org"
for cb in $COOKBOOKS; do
  count=$(knife cookbook show $cb |wc -w |sed -e "s/\ //g")
  if [ $count -gt $VCOUNT ]; then
    echo "!! $cb -- excessive versions ($count)"
  fi
  sleep 5
done