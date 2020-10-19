#!/usr/bin/env bash

set -eux

AWS_PROFILE=${1}
STAGE=${2}

#==== Level1 =====
cd l1
# get stack info
SLS1_INFO=$(AWS_PROFILE=${AWS_PROFILE} STAGE=${STAGE} L2_KEY="L2_KEY" L2_HOST="L2_HOST" sls info)
L1_KEY=$(echo "${SLS1_INFO}" | grep l1Key | awk '{ print $2 }')
L1_HOST=$(echo "${SLS1_INFO}" | grep "GET" | awk '{ print $3 }' | sed -e 's$/hello$$g')

cd ../load_test
npm i

echo "Starting testing"
HOST=${L1_HOST} API_KEY=${L1_KEY} npm test