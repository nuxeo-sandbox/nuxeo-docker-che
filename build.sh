#!/bin/bash -e

DOCKER_REGISTRY="dockerpriv.nuxeo.com"
DOCKER_IMAGE_BASE="test/che-base"
DOCKER_IMAGE="test/che"

QUICK=${QUICK:-false}
NUXEO_VERSION=${1:-8.3}

# XXX Do not use CDN and switch URL if version is `-SNAPSHOT`
NUXEO_MD5=`curl -s "http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip.md5" | awk  '{print \$1}'`

echo "Building CHE image for Nuxeo Server $NUXEO_VERSION..."
echo "MD5: $NUXEO_MD5"

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
WORKDIR=$DIR/workdir

SOURCE_FOLDER=$WORKDIR/nuxeo-sources
SOURCE_LINK=$DIR/nuxeo-che/nuxeo

M2_FOLDER=$WORKDIR/m2-$NUXEO_VERSION
M2_LINK=$DIR/nuxeo-che/m2

# Set -x after variables setting...
set -x

mkdir -p $WORKDIR
docker build -t $DOCKER_IMAGE_BASE nuxeo-che-base
docker tag $DOCKER_IMAGE_BASE $DOCKER_REGISTRY/$DOCKER_IMAGE_BASE
docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_BASE

if [ -d $SOURCE_FOLDER ]; then
  cd $SOURCE_FOLDER && git checkout . && git clean -fd && git fetch --all && cd $DIR
else
  # XXX, we need to handle -SNAPSHOT versions
  git clone https://github.com/nuxeo/nuxeo.git $SOURCE_FOLDER 
fi
git checkout release-$NUXEO_VERSION && git clean -fd

# XXX Run maven build inside a container...
# XXX: Must be installed: node, npm, grunt-cli, bower and gulp. Do not forget to link `nodejs` to `node` on Ubuntu.
$QUICK || (cd $SOURCE_FOLDER && mvn install test-compile -DskipTests -Dmaven.repo.local=$M2_FOLDER)

$QUICK || (rm -rf $M2_LINK && cp -R $M2_FOLDER $M2_LINK)
$QUICK || (rm -rf $SOURCE_LINK && cp -R $SOURCE_FOLDER $SOURCE_LINK)

_XX_NUXEO_VERSION=$NUXEO_VERSION _XX_NUXEO_MD5=$NUXEO_MD5 envsubst '$_XX_NUXEO_VERSION:$_XX_NUXEO_MD5' < $DIR/install_nuxeo.tpl.sh > $DIR/nuxeo-che/install_nuxeo.sh
chmod +x $DIR/nuxeo-che/install_nuxeo.sh
cd $DIR && docker build -t $DOCKER_IMAGE:$NUXEO_VERSION nuxeo-che
docker tag $DOCKER_IMAGE:$NUXEO_VERSION $DOCKER_REGISTRY/$DOCKER_IMAGE:$NUXEO_VERSION
docker push $DOCKER_REGISTRY/$DOCKER_IMAGE:$NUXEO_VERSION
