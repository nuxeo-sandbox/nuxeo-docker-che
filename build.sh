#!/bin/bash -e

QUICK=true

NUXEO_VERSION=${1:-8.3}
# XXX Do not use CDN and switch URL if version is `-SNAPSHOT`
NUXEO_MD5=`curl -s "http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip.md5" | awk  '{print \$1}'`

echo "Building CHE image for Nuxeo Server $NUXEO_VERSION..."
echo "MD5: $NUXEO_MD5"

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
WORKDIR=$DIR/workdir

SOURCE_FOLDER=$WORKDIR/nuxeo-$NUXEO_VERSION
SOURCE_LINK=$DIR/nuxeo-che/nuxeo

M2_FOLDER=$WORKDIR/m2-$NUXEO_VERSION
M2_LINK=$DIR/nuxeo-che/m2

# Set -x after variables setting...
set -x

mkdir -p WORKDIR
docker build -t nuxeo-che-base nuxeo-che-base

if [ -d $SOURCE_FOLDER ]; then
  cd $SOURCE_FOLDER && git checkout . && git clean -fd && git pull --rebase && cd $DIR
else
  # XXX, we need to handle -SNAPSHOT versions
  git clone git@github.com:nuxeo/nuxeo.git $SOURCE_FOLDER && git checkout release-$NUXEO_VERSION
fi
$QUICK || (cd $SOURCE_FOLDER && mvn install test-compile -DskipTests -Dmaven.repo.local=$M2_FOLDER && cd $DIR)

$QUICK || (rm -rf $M2_LINK && cp -R $M2_FOLDER $M2_LINK)
$QUICK || (rm -rf $SOURCE_LINK && cp -R $SOURCE_FOLDER $SOURCE_LINK)

_XX_NUXEO_VERSION=$NUXEO_VERSION _XX_NUXEO_MD5=$NUXEO_MD5 envsubst '$_XX_NUXEO_VERSION:$_XX_NUXEO_MD5' < install_nuxeo.tpl.sh > $DIR/nuxeo-che/install_nuxeo.sh
chmod +x $DIR/nuxeo-che/install_nuxeo.sh
docker build -t nuxeo-che:$NUXEO_VERSION nuxeo-che
