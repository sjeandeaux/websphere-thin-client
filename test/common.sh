#!/usr/bin/env bash

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)"
export PATH="$JAVA_HOME/bin:$PATH"

HOST_NAME='localhost'

if [ ! -d /tmp/websphere-thin-client ]; then
  unzip -o /current/target/websphere-thin-client-*.zip -d /tmp
fi 
cd /tmp/websphere-thin-client/bin
/tmp/websphere-thin-client/bin/addcertificate.sh ${HOST_NAME}
