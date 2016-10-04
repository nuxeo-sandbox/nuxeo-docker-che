#!/bin/bash -ex

PUSH=${PUSH:-false}
DOCKER_IMAGE_BASE=${DOCKER_IMAGE_BASE:-"nuxeo/che-base"}
DOCKER_IMAGE=${DOCKER_IMAGE:-"nuxeo/che-workspace"}

QUICK=${QUICK:-false}
# Latest version should be tired from connect TP
NUXEO_VERSION=${1:-master}

if [[ "${NUXEO_VERSION}" =~ ^([0-9\.]+)-SNAPSHOT$ ]] || [[ "${NUXEO_VERSION}" =~ ^master$ ]];
then
  # Snapshot version; use static to resolve MD5
  NUXEO_MD5_URL=`curl -Ls -o /dev/null -w %{url_effective} http://community.nuxeo.com/static/latest-snapshot/nuxeo,tomcat,md5,${BASH_REMATCH[1]}`
else
  # Release version; use the CDN
  # NUXEO_MD5_URL="http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip.md5"
  # NUXEO_URL="http://cdn.nuxeo.com/nuxeo-${NUXEO_VERSION}/nuxeo-server-${NUXEO_VERSION}-tomcat.zip"
  NUXEO_MD5_URL=`curl -Ls -o /dev/null -w %{url_effective} http://community.nuxeo.com/static/latest-release/nuxeo,tomcat,md5,${NUXEO_VERSION}`
fi

NUXEO_URL=${NUXEO_MD5_URL%.md5}
NUXEO_MD5=`curl -sL "${NUXEO_MD5_URL}" | awk '{print \$1}'`
if ! [[ "${NUXEO_MD5}" =~ ^[a-f0-9]{32}$ ]]; then
  echo "Unable to read MD5 from version ${NUXEO_VERSION}"
  exit 1
fi;

echo "Building CHE image for Nuxeo Server $NUXEO_VERSION..."
echo "MD5: $NUXEO_MD5"
echo "URL: $NUXEO_URL"

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
! ${PUSH} || docker push $DOCKER_IMAGE_BASE

if [ -d $SOURCE_FOLDER ]; then
  cd $SOURCE_FOLDER && git checkout . && git clean -fd && git fetch --all
else
  # XXX, we need to handle -SNAPSHOT versions
  git clone https://github.com/nuxeo/nuxeo.git $SOURCE_FOLDER
fi
cd $SOURCE_FOLDER

# Checkout sources
# Use the tag if version is not snapshot; takes the branch otherwise
if [[ "${NUXEO_VERSION}" =~ ^([0-9\.]+)-SNAPSHOT$ ]];
then
  if [ `git branch --list ${BASH_REMATCH[1]}` ]; then
    GIT_REF=${BASH_REMATCH[1]}
  fi
else
  if [[ "${NUXEO_VERSION}" =~ ^([0-9\.]+)$ ]]; then
    GIT_REF="release-$NUXEO_VERSION"
  else
    GIT_REF=${NUXEO_VERSION}
  fi
fi
if [ -z $GIT_REF ]; then
  echo "Unable to resolve a git reference for version: ${NUXEO_VERSION}"
  exit 2
fi
git checkout ${GIT_REF} && git clean -fd

# XXX Run maven build inside a container...
# XXX: Must be installed: node, npm, grunt-cli, bower and gulp. Do not forget to link `nodejs` to `node` on Ubuntu.
$QUICK || (rm -rf $SOURCE_LINK && cp -R $SOURCE_FOLDER $SOURCE_LINK)

_XX_NUXEO_URL=$NUXEO_URL _XX_NUXEO_MD5=$NUXEO_MD5 envsubst '$_XX_NUXEO_URL:$_XX_NUXEO_MD5' < $DIR/install_nuxeo.tpl.sh > $DIR/nuxeo-che/install_nuxeo.sh
chmod +x $DIR/nuxeo-che/install_nuxeo.sh
cd $DIR && docker build -t $DOCKER_IMAGE:$NUXEO_VERSION nuxeo-che
! ${PUSH} || docker push $DOCKER_IMAGE:$NUXEO_VERSION


