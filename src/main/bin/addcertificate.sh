#!/bin/bash

host=${1-localhost}
port=${2-8880}
certificate=/tmp/$host.$port.crt
#ssl.client.props
storePass=KeyStorePassword

trustStore=${3-`dirname "$0"`}/../etc

##Create the trust store if it not exists
[ ! -e ${trustStore} ] && mkdir -p ${trustStore}

#generate the certificate
echo QUIT | openssl s_client -connect ${host}:${port} 2> /dev/null | openssl x509 -out ${certificate} >/dev/null 2>&1

result=$?
if [ ${result} -eq 0 ]
then

    keytool -delete -noprompt -alias ${host}_${port} -keystore ${trustStore}/truststore.jks -storepass ${storePass} \
             >/dev/null 2>&1

    keytool -import -noprompt -alias ${host}_${port} -keystore ${trustStore}/truststore.jks -storepass ${storePass} \
             -file ${certificate} >/dev/null 2>&1 || echo "warning on keytool $host $port"

else
    echo "warning on openssl $host $port"
fi

#always OK
exit 0
