#!/bin/bash
export ENVIRONMENT_NAME=`cat /app/environment_name`
export BUILD_BRANCH=`cat /app/build_branch`
tail -f /dev/null

