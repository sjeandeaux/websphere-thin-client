#!/usr/bin/env bash

source /current/test/common.sh

set -o errexit
set -o pipefail
set -o nounset

/tmp/websphere-thin-client/bin/wsadmin.sh \
             -host ${HOST_NAME} \
             -user wsadmin \
             -password was \
             -f ../scripts/wonderful-script.py
