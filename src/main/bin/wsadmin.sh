#!/bin/bash

set +x

THIN_CLIENT_ROOT=`dirname "$0"`
THIN_CLIENT_ROOT="$THIN_CLIENT_ROOT/.."


if [[ -f ${JAVA_HOME}/bin/java ]]; then
   JAVA_EXE="${JAVA_HOME}/bin/java"
else
   JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

#wsadminTraceString=-Dcom.ibm.ws.scripting.traceString=com.ibm.*=all=enabled
wsadminEchoparams=-Dcom.ibm.ws.scripting.echoparams=false
wsadminTraceFile=-Dcom.ibm.ws.scripting.traceFile=${THIN_CLIENT_ROOT}/logs/wsadmin.traceout
wsadminValOut=-Dcom.ibm.ws.scripting.validationOutput=${THIN_CLIENT_ROOT}/logs/wsadmin.valout

wsadminHost=-Dcom.ibm.ws.scripting.host=localhost
wsadminConnType=-Dcom.ibm.ws.scripting.connectionType=SOAP
wsadminPort=-Dcom.ibm.ws.scripting.port=8880
wsadminLang=-Dcom.ibm.ws.scripting.defaultLang=jython

sslURL="-Dcom.ibm.SSL.ConfigURL=file:${THIN_CLIENT_ROOT}/properties/ssl.client.props"
soapURL="-Dcom.ibm.SOAP.ConfigURL=${THIN_CLIENT_ROOT}/properties/soap.client.props"

# Parse the input arguments
isJavaOption=false
nonJavaOptionCount=1
for option in "$@" ; do
  if [ "$option" = "-javaoption" ] ; then
     isJavaOption=true
  else
     if [ "$isJavaOption" = "true" ] ; then
        javaOption="$javaOption $option"
        isJavaOption=false
     else
        nonJavaOption[$nonJavaOptionCount]="$option"
        nonJavaOptionCount=$((nonJavaOptionCount+1))
     fi
  fi
done


if [[ -z "${JAASSOAP}" ]]; then
     JAASSOAP="-Djaassoap=off"
fi

"${JAVA_EXE}" \
    -Xms256m -Xmx256m \
    -Djava.util.logging.manager=com.ibm.ws.bootstrap.WsLogManager -Djava.util.logging.configureByServer=true \
    ${javaOption} \
    -Dws.output.encoding=console \
    "${sslURL}" \
    "${soapURL}" \
    "${JAASSOAP}" \
    "-Duser.install.root=${THIN_CLIENT_ROOT}" \
    "-Duser.root=${THIN_CLIENT_ROOT}" \
    "-Dwas.install.root=${THIN_CLIENT_ROOT}" \
    "-Dcom.ibm.websphere.thinclient=true" \
    ${wsadminTraceFile} \
    ${wsadminTraceString} \
    ${wsadminValOut} \
    ${wsadminHost} \
    ${wsadminConnType} \
    ${wsadminPort} \
    ${wsadminLang} \
    ${wsadminEchoparams} \
    -classpath \
    "${THIN_CLIENT_ROOT}/lib/*" \
    com.ibm.ws.scripting.WasxShell \
    "${nonJavaOption[@]}"

exit $?