FROM ibmcom/websphere-traditional:8.5.5.11-profile

USER root
RUN apt-get update && apt-get install -y unzip openjdk-8-jdk

RUN echo was > /tmp/PASSWORD
