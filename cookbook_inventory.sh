#!/bin/bash
# Search Chef for cookbooks not in a run_list

ARCHIVE=""

while getopts "a:" op; do
  case $op in
    a) ARCHIVE=$OPTARG ;;
  esac
done

if [ -n "$ARCHIVE" ]; then
  CB_CMD="cat $ARCHIVE"
else
  CB_CMD="knife cookbook list"
fi
COOKBOOKS=$($CB_CMD |awk '{print $1}' |egrep -v '^.*_test$')
CB_COUNT=$(echo $COOKBOOKS 2>/dev/null|wc -w |sed -e "s/\ //g")

echo "***** Processing $CB_COUNT cookbooks in Chef org"
for cb in $COOKBOOKS; do
  count=$(knife search node "recipes:${cb}\:\:*" -i 2>/dev/null |wc -l |sed -e "s/\ //g")
  if [ $count -eq 0 ]; then
    echo "!! $cb -- does not appear in any expanded run_list"
  fi
  sleep 5
done