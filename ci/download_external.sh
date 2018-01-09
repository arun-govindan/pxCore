#!/bin/sh
#export DEPLOY_DESTINATION=${DEPLOY_DESTINATION:-/var/www/html/ciresults}
export DEPLOY_USER="${DEPLOY_USER:-ubuntu}"
REMOTE_HOST="$1"
DEST_FILE="$2"
#since we saved $1 to REMOTE_HOST delete it from args via shift
#export REMOTE_FILE_COUNT=$(ssh -o StrictHostKeyChecking=no -p 2220 ${DEPLOY_USER}@${REMOTE_HOST} "ls -lrt $DEPLOY_DESTINATION|grep "external"|wc -l")
export REMOTE_FILE=$(ssh -o StrictHostKeyChecking=no -p 2220 ${DEPLOY_USER}@${REMOTE_HOST} "ls -t $DEPLOY_DESTINATION|grep "external" |tail -1")
#export REMOTE_TEMPDIR=$(ssh -o StrictHostKeyChecking=no -p 2220 ${DEPLOY_USER}@${REMOTE_HOST} "mktemp -d")
#echo ${REMOTE_DIR}
scp -P 2220 ${DEPLOY_USER}@${REMOTE_HOST}:${REMOTE_FILE} ${DEST_FILE}
