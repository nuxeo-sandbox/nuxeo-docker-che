# vim:set ft=dockerfile:
FROM test/che-base
MAINTAINER Nuxeo <packagers@nuxeo.com>

COPY ["install_nuxeo.sh", "/tmp/install_nuxeo.sh"]
COPY ["nuxeo", "/opt/nuxeo"]
COPY ["m2", "/home/user/.m2/repository"]

USER $NUXEO_USER
RUN  bash /tmp/install_nuxeo.sh && \
     sudo chown -R user:user /home/user/.m2/ /opt/

COPY ["settings.xml", "/home/user/.m2/"]
WORKDIR /projects

CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
