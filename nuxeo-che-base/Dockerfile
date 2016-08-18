# vim:set ft=dockerfile:
FROM java:8-jdk
MAINTAINER Nuxeo <packagers@nuxeo.com>

ENV NUXEO_USER=nuxeo \
    NODE_VERSION=6.2.2 \
    NODE_PATH=/usr/local/lib/node_modules \
    MAVEN_VERSION=3.3.9

ENV M2_HOME=/home/nuxeo/apache-maven-$MAVEN_VERSION
ENV PATH=$M2_HOME/bin:$PATH

# Create Nuxeo user
RUN useradd -m -d /home/$NUXEO_USER -s /bin/bash $NUXEO_USER

# Add needed convert tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    perl \
    locales \
    pwgen \
    imagemagick \
    ffmpeg2theora \
    ufraw \
    poppler-utils \
    libreoffice \
    libwpd-tools \
    exiftool \
    ghostscript \
    subversion

 # Add maven
 RUN mkdir /home/nuxeo/apache-maven-$MAVEN_VERSION && \
     wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/nuxeo/apache-maven-$MAVEN_VERSION/

 # Add node.js
 RUN cd /home/nuxeo && curl --insecure -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
     && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
     && rm -rf node-v$NODE_VERSION-linux-x64.tar.gz

ONBUILD RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*
