#!/bin/bash -ex

PUSH=${PUSH:-false}
DOCKER_IMAGE=${DOCKER_IMAGE:-"nuxeo/che-workspace"}
DOCKER_TAG=${NUXEO_VERSION:-"temp"}
NUXEO_VERSION=${NUXEO_VERSION:-"8.10"}

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
WORKDIR=$DIR/workdir

# Set -x after variables setting...
set -x

_XX_NUXEO_GITREF=release-${NUXEO_VERSION} envsubst '$_XX_NUXEO_GITREF' < $DIR/install_nuxeo.tpl.sh > $DIR/nuxeo-che/install_nuxeo.sh
chmod +x $DIR/nuxeo-che/install_nuxeo.sh
cd $DIR && docker build -t $DOCKER_IMAGE:$DOCKER_TAG nuxeo-che
! ${PUSH} || docker push $DOCKER_IMAGE:$DOCKER_TAG

