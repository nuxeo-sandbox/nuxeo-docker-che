# vim:set ft=dockerfile:
FROM nuxeo/che-base
MAINTAINER Nuxeo <packagers@nuxeo.com>

COPY ["nuxeo", "/opt/nuxeo"]
COPY ["install_nuxeo.sh", "/tmp/install_nuxeo.sh"]
COPY ["settings.xml", "/home/user/.m2/"]

RUN  bash /tmp/install_nuxeo.sh

USER $NUXEO_USER
WORKDIR /projects
CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
