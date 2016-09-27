# vim:set ft=dockerfile:
FROM nuxeo/che-base
MAINTAINER Nuxeo <packagers@nuxeo.com>

COPY ["install_nuxeo.sh", "/tmp/install_nuxeo.sh"]
COPY ["nuxeo", "/opt/nuxeo"]

RUN  bash /tmp/install_nuxeo.sh && \
     sudo chown -R user:user /home/user/.m2/ /opt/

USER $NUXEO_USER
COPY ["settings.xml", "/home/user/.m2/"]
WORKDIR /projects

CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
