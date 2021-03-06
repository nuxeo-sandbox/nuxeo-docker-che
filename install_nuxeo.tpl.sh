#!/bin/bash -ex

export NUXEO_GITREF=$_XX_NUXEO_GITREF
export NUXEO_SOURCES=/opt/nuxeo/sources

# Ensure all userland directories have good rights
sudo mkdir -p /var/run/nuxeo
sudo chown -R $CHE_USER:0 /home/user/.m2/ /opt/ /var/run/nuxeo
su $CHE_USER -c "git clone https://github.com/nuxeo/nuxeo.git ${NUXEO_SOURCES} && cd ${NUXEO_SOURCES} && git checkout ${NUXEO_GITREF} && git clean -fd"
cd ${NUXEO_SOURCES} && su $CHE_USER -c "MAVEN_OPTS=\"-Xmx2g\" PATH=$PATH:$M2_HOME/bin mvn install process-test-classes -DskipTests"
