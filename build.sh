#!/bin/bash -ex

PUSH=${PUSH:-false}

DOCKER_IMAGE=${DOCKER_IMAGE:-"nuxeo/che-workspace"}
NODE_VERSION=${NODE_VERSION:-"7.5.0"}
MAVEN_VERSION=${MAVEN_VERSION:-"3.3.9"}

# If no version specified; we are build the new latest image based on the master branch
DOCKER_TAG=${NUXEO_VERSION:-"latest"}
NUXEO_VERSION=${NUXEO_VERSION:-"master"}

DOCKER_PARAMS=""

if [[ ${NUXEO_VERSION} =~ ^[1-9][0-9]*\.[0-9]+(\.[0-9]+)?$ ]]; then
  NUXEO_GITREF="release-${NUXEO_VERSION}"
else
  NUXEO_GITREF='master'
  DOCKER_PARAMS='--no-cache'
fi

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
WORKDIR=$DIR/workdir

_XX_PARENT_VERSION=${NUXEO_VERSION} _XX_MAVEN_VERSION=${MAVEN_VERSION} _XX_NODE_VERSION=${NODE_VERSION} envsubst '$_XX_PARENT_VERSION:$_XX_MAVEN_VERSION:$_XX_NODE_VERSION' < $DIR/Dockerfile.tpl > $DIR/nuxeo-che/Dockerfile
_XX_NUXEO_GITREF=${NUXEO_GITREF} envsubst '$_XX_NUXEO_GITREF' < $DIR/install_nuxeo.tpl.sh > $DIR/nuxeo-che/install_nuxeo.sh

chmod +x $DIR/nuxeo-che/install_nuxeo.sh
cd $DIR && docker build ${DOCKER_PARAMS} -t $DOCKER_IMAGE:$DOCKER_TAG nuxeo-che
! ${PUSH} || docker push $DOCKER_IMAGE:$DOCKER_TAG

