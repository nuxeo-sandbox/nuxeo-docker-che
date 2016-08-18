# vim:set ft=dockerfile:
FROM nuxeo-che-base
MAINTAINER Nuxeo <packagers@nuxeo.com>

COPY ["nuxeo", "/projects/nuxeo"]
COPY ["m2", "/home/nuxeo/.m2/repository"]

COPY ["install_nuxeo.sh", "/root/install_nuxeo.sh"]
RUN  ["bash", "/root/install_nuxeo.sh"]

USER $NUXEO_USER

CMD /bin/bash
