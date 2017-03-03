# vim:set ft=dockerfile:
FROM nuxeo/nuxeo:$_XX_PARENT_VERSION
MAINTAINER Nuxeo <packagers@nuxeo.com>

ENV CHE_USER=user \
    NUXEO_USER=user \
    NODE_VERSION=$_XX_NODE_VERSION \
    NODE_PATH=/usr/local/lib/node_modules \
    MAVEN_VERSION=$_XX_MAVEN_VERSION

ENV M2_HOME=/home/$CHE_USER/apache-maven-$MAVEN_VERSION
ENV PATH=$M2_HOME/bin:$PATH

# Add needed convert tools
EXPOSE 4403 8000 8080 8787 9876 22
RUN apt-get update && \
    apt-get -y install sudo openssh-server rsync vim procps wget unzip mc curl git software-properties-common python-software-properties && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd -u 1001 -G users,sudo -d /home/user --shell /bin/bash -m user && \
    addgroup nuxeo sudo && \
    echo "secret\nsecret" | passwd user && \
    apt-get clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# Add maven and node.js
RUN mkdir /home/$CHE_USER/apache-maven-$MAVEN_VERSION && \
    wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C $M2_HOME && \
    cd /home/$CHE_USER && curl --insecure -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm -rf node-v$NODE_VERSION-linux-x64.tar.gz \
    && npm install -g yo generator-nuxeo grunt-cli gulp bower

COPY ["README.md", "/opt/README.md"]
COPY ["install_nuxeo.sh", "/tmp/install_nuxeo.sh"]
COPY ["settings.xml", "/home/user/.m2/"]

RUN  bash /tmp/install_nuxeo.sh
  
COPY ["entrypoint.sh", "/entrypoint.sh"]
# XXX Override default nuxeo docker-entrypoint.sh file
COPY ["docker-entrypoint.sh", "/docker-entrypoint.sh"]
USER user
WORKDIR /projects
ENTRYPOINT ["/entrypoint.sh"]
CMD tail -f /dev/null
