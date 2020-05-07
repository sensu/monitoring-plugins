#!/usr/bin/env bash
##
# Adapted from sensu/sensu-go-bonsai-asset repo
##

# Hardwiring repo-name for now, untile the Dockerfile logic is abstracted/tested to use name as passed to docker as build arg
REPO_NAME="monitoring-plugins"

export PLUGINS="check_disk,check_dns,check_http,check_load,check_log,check_ntp,check_ntp_peer,check_ntp_time,check_ping,check_procs,check_smtp,check_snmp,check_ssh,check_swap,check_tcp,check_time,check_users,utils.sh"

[[ -z "$WDIR" ]] && { echo "WDIR is empty using bonsai/" ; WDIR="bonsai/"; }

##
# TravisCI specific asset build script.
#   Uses several TravisCI specific environment variables 
##
#[[ -z "$1" ]] && { echo "Parameter 1, REPO_NAME is empty" ; exit 1; }
[[ -z "$GITHUB_TOKEN" ]] && { echo "GITHUB_TOKEN is empty, upload disabled" ; }
[[ -z "$TRAVIS_REPO_SLUG" ]] && { echo "TRAVIS_REPO_SLUG is empty"; exit 1; }
if [[ -z "$1" ]]; then 
  echo "Parameter 1, PLATFORMS is empty, using default set" ; platforms=( alpine alpine3.8 debian8 debian9 debian10 centos8 centos7 centos6 amazon1 amazon2 ubuntu1404 ubuntu1604 ubuntu1804 ubuntu2004 ); 
else
  IFS=', ' read -r -a platforms <<< "$1"
fi
TAG=$TRAVIS_TAG
CURRENT_COMMIT=$(git rev-parse HEAD)
[[ -z "$TAG" ]] && { echo "TRAVIS_TAG is empty" ; TAG="0.0.1"; }
[[ -z "$TRAVIS_COMMIT" ]] && { echo "TRAVIS_COMMIT is empty, using current commit" ; TRAVIS_COMMIT=$CURRENT_COMMIT; }
echo $REPO_NAME $TRAVIS_REPO_SLUG $TAG $TRAVIS_COMMIT

mkdir dist
GIT_REPO="https://github.com/${TRAVIS_REPO_SLUG}.git"
GIT_REF=${TRAVIS_COMMIT}

echo "Platforms: ${platforms[@]}"

if [ -d dist ]; then
  for platform in "${platforms[@]}"
  do
  if [ -f "Dockerfile.${platform}" ]; then
    export SENSU_GO_ASSET_FILENAME="${REPO_NAME}-${platform}_${TAG}_linux_amd64.tar.gz"
    echo "Building for Platform: $platform using Dockfile.${platform} ${SENSU_GO_ASSET_FILENAME}"	  
    docker build --no-cache --rm --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=${TAG}" -t ${REPO_NAME}-${platform}:$TAG -f Dockerfile.${platform} .
    docker cp -L $(docker create --rm ${REPO_NAME}-${platform}:${TAG} true):/$SENSU_GO_ASSET_FILENAME ./dist/
  else
    echo "Skipping for Platform: $platform missing Dockfile.${platform}"	  
  fi 	  
  done
else
  echo "error dist directory is missing"
fi





