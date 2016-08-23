# vim:set ft=dockerfile:
FROM java:8-jdk
MAINTAINER Nuxeo <packagers@nuxeo.com>

ENV NUXEO_USER=user \
    NODE_VERSION=6.2.2 \
    NODE_PATH=/usr/local/lib/node_modules \
    MAVEN_VERSION=3.3.9

ENV M2_HOME=/home/$NUXEO_USER/apache-maven-$MAVEN_VERSION
ENV PATH=$M2_HOME/bin:$PATH

# Add needed convert tools
EXPOSE 4403 8000 8080 9876 22
RUN apt-get update && \
    apt-get -y install sudo openssh-server vim procps wget unzip mc curl subversion software-properties-common python-software-properties && \
    apt-get -y install --no-install-recommends perl git locales pwgen imagemagick ffmpeg2theora ufraw poppler-utils libreoffice libwpd-tools exiftool ghostscript subversion && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -u 1000 -G users,sudo -d /home/user --shell /bin/bash -m user && \
    echo "secret\nsecret" | passwd user && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# Add maven
RUN mkdir /home/$NUXEO_USER/apache-maven-$MAVEN_VERSION && \
    wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C $M2_HOME

 # Add node.js
RUN cd /home/$NUXEO_USER && curl --insecure -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm -rf node-v$NODE_VERSION-linux-x64.tar.gz \
    && npm install -g yo generator-nuxeo grunt-cli gulp bower

ONBUILD RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*
