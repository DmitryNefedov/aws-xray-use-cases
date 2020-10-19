#!/usr/bin/env bash

set -eux

AWS_PROFILE=${1}
STAGE=${2}

#==== Level3 =====
cd l3
# install dependencies and deploy serverless
npm i
AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} sls deploy -v

#get stack info
SLS3_INFO=$(AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} sls info)
L3_KEY=$(echo "${SLS3_INFO}" | grep l3Key | awk '{ print $2 }')
L3_HOST=$(echo "${SLS3_INFO}" | grep "GET" | awk '{ print $3 }')

#==== Level2 =====
cd ../l2
# install dependencies and deploy serverless
npm i
AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} L3_KEY=${L3_KEY} L3_HOST=${L3_HOST} sls deploy -v

# get stack info
SLS2_INFO=$(AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} L3_KEY=${L3_KEY} L3_HOST=${L3_HOST} sls info)
L2_KEY=$(echo "${SLS2_INFO}" | grep l2Key | awk '{ print $2 }')
L2_HOST=$(echo "${SLS2_INFO}" | grep "GET" | awk '{ print $3 }')

# upload data to dynamoDb
aws dynamodb put-item --table-name orgTable-${STAGE} --item file://data1.json --profile ${AWS_PROFILE} >> /dev/null
aws dynamodb put-item --table-name orgTable-${STAGE} --item file://data2.json --profile ${AWS_PROFILE} >> /dev/null

#==== Level1 =====
cd ../l1
# install dependencies and deploy serverless
npm i
AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} L2_KEY=${L2_KEY} L2_HOST=${L2_HOST} sls deploy -v

# get stack info
SLS1_INFO=$(AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} L2_KEY=${L2_KEY} L2_HOST=${L2_HOST} sls info)
L1_KEY=$(echo "${SLS1_INFO}" | grep l1Key | awk '{ print $2 }')
L1_HOST=$(echo "${SLS1_INFO}" | grep "GET" | awk '{ print $3 }')


set +x
echo "==== print out URL and API-Keys====="

echo "Level3:"
echo "${L3_HOST}"
echo "${L3_KEY}"
echo ""

echo "Level2:"
echo "${L2_HOST}"
echo "${L2_KEY}"
echo ""

echo "Level1:"
echo "${L1_HOST}"
echo "${L1_KEY}"
