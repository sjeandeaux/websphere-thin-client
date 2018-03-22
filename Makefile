PWD=$(shell pwd)

.PHONY: src/main/*

help: ## this help
	@grep -hE '^[a-zA-Z_-]+.*?:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

was8:build ## run websphere 8 (before rm and build)
	docker run -d -v $(PWD):/current -p 9043:9043 -p 9060:9060 -p 8880:8880 --name websphere-thin-client-test websphere-thin-client:0.1.0

define copy-and-install
	docker cp websphere-thin-client-test:$2/$1 lib/$1
	mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=lib/$1 \
                                                                              -DgroupId=$3 \
                                                                              -DartifactId=$4 \
                                                                              -Dversion=$5 \
                                                                              -Dpackaging=jar \
                                                                              -DlocalRepositoryPath=./repository
endef

local-repo:was8
	rm -fr lib || true
	rm -fr repository || true  
	mkdir lib 
	mkdir repository
	$(call copy-and-install,com.ibm.ws.admin.client_8.5.0.jar,/opt/IBM/WebSphere/AppServer/runtimes,com.ibm.ws.admin.client,client,8.5.5.11)
	$(call copy-and-install,com.ibm.ws.orb_8.5.0.jar,/opt/IBM/WebSphere/AppServer/deploytool/itp/plugins/com.ibm.websphere.v85.core_1.0.1.v20121015_1658/wasJars,com.ibm.ws.orb,orb,8.5.5.11)
	$(call copy-and-install,com.ibm.ws.security.crypto.jar,/opt/IBM/WebSphere/AppServer/plugins,com.ibm.ws.security.crypto,crypto,8.5.5.11)
	$(call copy-and-install,ibmkeycert.jar,/opt/IBM/WebSphere/AppServer/java/jre/lib/ext,com.ibm.jdk,ibmkeycert,8.5.5.11)
	$(call copy-and-install,ibmpkcs.jar,/opt/IBM/WebSphere/AppServer/java/jre/lib,com.ibm.jdk,ibmpkcs,8.5.5.11)

build:rm ## build the docker image
	docker build --no-cache -t websphere-thin-client:0.1.0 .

rm: ## remove the container
	docker rm -f websphere-thin-client-test || true

wonderful-script: ## run wonderful-script.py
	docker exec -ti websphere-thin-client-test /current/test/wonderful-script.sh

src/main/*: ## update the scripts jython
	docker cp $(PWD)/$@ websphere-thin-client-test:/tmp/websphere-thin-client/
