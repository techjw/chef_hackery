#!/bin/bash
# Search Chef for AWS nodes that no longer exist

use1_output=$(aws --region us-east-1 ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateDnsName,Tags[?Key==`Name`].Value]')
usw2_output=$(aws --region us-west-2 ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PrivateDnsName,Tags[?Key==`Name`].Value]')

for node in $(knife node list); do
  if [[ -z $(echo "$use1_output" |egrep $node) ]] &&
     [[ -z $(echo "$usw2_output" |egrep $node) ]] ; then
    printf "%-32s %s\n" $node "No matching AWS instance"
  fi
done