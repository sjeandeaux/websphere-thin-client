# websphere thin client

[![Build Status](https://travis-ci.org/sjeandeaux/websphere-thin-client.svg?branch=develop)](https://travis-ci.org/sjeandeaux/websphere-thin-client)

TIPS:

* [console](http://localhost:9060/ibm/console)

## installation

## All you need is love and these following jars

* com.ibm.ws.admin.client_8.5.0.jar (/opt/IBM/WebSphere/AppServer/runtimes/com.ibm.ws.admin.client_8.5.0.jar)
* com.ibm.ws.security.crypto.jar (/opt/IBM/WebSphere/AppServer/plugins/com.ibm.ws.security.crypto.jar)
* ibmkeycert.jar (/opt/IBM/WebSphere/AppServer/java/jre/lib/ext/ibmkeycert.jar)
* ibmpkcs.jar (/opt/IBM/WebSphere/AppServer/java/jre/lib/ibmpkcs.jar)

```bash
mvn clean verify
```

## Play

```bash
./wsadmin.sh \
             -host <your host> \
             -user wsadmin \
             -password was \
             -f wonderful-script.py \
```


## Jenkins 

### Plugin Custom Tools

TODO

### How do we use it


TODO
