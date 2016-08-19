# vim:set ft=dockerfile:
FROM test/che-base
MAINTAINER Nuxeo <packagers@nuxeo.com>

COPY ["nuxeo", "/opt/nuxeo"]
COPY ["m2", "/home/user/.m2/repository"]

COPY ["install_nuxeo.sh", "/tmp/install_nuxeo.sh"]

USER $NUXEO_USER
RUN  ["bash", "/tmp/install_nuxeo.sh"]

WORKDIR /projects

CMD sudo /usr/sbin/sshd -D && \
    tail -f /dev/null
