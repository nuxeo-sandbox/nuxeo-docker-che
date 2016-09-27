#!/bin/bash -ex

export NUXEO_MD5=$_XX_NUXEO_MD5
export NUXEO_URL=$_XX_NUXEO_URL
export NUXEO_HOME=/opt/server

# curl -fsSL "http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip" -o /tmp/nuxeo-distribution-tomcat.zip \
curl -fsSL "${NUXEO_URL}" -o /tmp/nuxeo-distribution-tomcat.zip \
    && echo "$NUXEO_MD5 /tmp/nuxeo-distribution-tomcat.zip" | md5sum -c - \
    && mkdir -p /tmp/nuxeo-distribution $(dirname $NUXEO_HOME) \
    && unzip -q -d /tmp/nuxeo-distribution /tmp/nuxeo-distribution-tomcat.zip \
    && DISTDIR=$(/bin/ls /tmp/nuxeo-distribution | head -n 1) \
    && sudo mv /tmp/nuxeo-distribution/$DISTDIR $NUXEO_HOME  \
    && sed -i -e "s/^nuxeo.wizard.done.*//" $NUXEO_HOME/bin/nuxeo.conf \
    && sed -i -e "s/^#?\(facelets.REFRESH_PERIOD=.*\)$/\1/g" $NUXEO_HOME/bin/nuxeo.conf \
    && sed -i -e "s/^#?\(JAVA_OPTS=.*-Xdebug -Xrunjdwp.*\)$/\1/g" $NUXEO_HOME/bin/nuxeo.conf \
    && rm -rf /tmp/nuxeo-distribution* \
    && chmod +x $NUXEO_HOME/bin/*ctl $NUXEO_HOME/bin/*.sh

cd /opt/nuxeo && sudo mvn clean install process-test-classes -DskipTests