#!/usr/bin/env bash
##
# Adapted from sensu/sensu-go-bonsai-asset repo
##

# Hardwiring repo-name for now, untile the Dockerfile logic is abstracted/tested to use name as passed to docker as build arg
REPO_NAME="monitoring-plugins"

export PLUGINS="check_disk,check_http,check_ntp,check_ntp_peer,check_ntp_time,check_ping,check_procs,check_smtp,check_ssh,check_swap,check_tcp,check_time,check_users"

[[ -z "$WDIR" ]] && { echo "WDIR is empty using bonsai/" ; WDIR="bonsai/"; }

##
# TravisCI specific asset build script.
#   Uses several TravisCI specific environment variables 
##
#[[ -z "$1" ]] && { echo "Parameter 1, REPO_NAME is empty" ; exit 1; }
[[ -z "$GITHUB_TOKEN" ]] && { echo "GITHUB_TOKEN is empty, upload disabled" ; }
[[ -z "$TRAVIS_REPO_SLUG" ]] && { echo "TRAVIS_REPO_SLUG is empty"; exit 1; }
if [[ -z "$1" ]]; then 
  echo "Parameter 1, PLATFORMS is empty, using default set" ; platforms=( alpine debian centos alpine3.8 debian9 centos7 centos6 amazon); 
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
  #docker build --build-arg "ASSET_GEM=${GEM_NAME}" --build-arg "GIT_REPO=${GIT_REPO}"  --build-arg "GIT_REF=${GIT_REF}" -t ruby-plugin-${platform} -f "${WDIR}/ruby-runtime/Dockerfile.${platform}" .
  #docker cp $(docker create --rm ruby-plugin-${platform}:latest sleep 0):/${GEM_NAME}.tar.gz ./dist/${GEM_NAME}_${TAG}_${platform}_linux_amd64.tar.gz
  done

  # Generate the sha512sum for all the assets
  files=$( ls dist/*.tar.gz )
  echo $files
  for filename in $files; do
    if [[ "$TRAVIS_TAG" ]]; then
      if [[ "$GITHUB_TOKEN" ]]; then
        if [[ "$TRAVIS_REPO_SLUG" ]]; then
          echo "upload $filename"
          ${WDIR}/github-release-upload.sh github_api_token=$GITHUB_TOKEN repo_slug="$TRAVIS_REPO_SLUG" tag="${TRAVIS_TAG}" filename="$filename"
        else
	  echo "TRAVIS_REPO_SLUG unset, skipping upload of $filename"      
	fi	 
      else
	echo "GITUB_TOKEN unset, skipping upload of $filename"      
      fi	
    fi
  done 
  file=$(basename "${files[0]}")
  IFS=_ read -r package leftover <<< "$file"
  unset leftover
  if [ -n "$package" ]; then
    echo "Generating sha512sum for ${package}"
    cd dist || exit
    sha512_file="${package}_${TAG}_sha512-checksums.txt"
    #echo "${sha512_file}" > sha512_file
    echo "sha512_file: ${sha512_file}"
    sha512sum ./*.tar.gz > "${sha512_file}"
    echo ""
    cat "${sha512_file}"
    cd ..
    if [[ "$TRAVIS_TAG" ]]; then
      if [[ "$GITHUB_TOKEN" ]]; then
        echo "upload ${sha512_file}"
        ${WDIR}/github-release-upload.sh github_api_token=$GITHUB_TOKEN repo_slug="$TRAVIS_REPO_SLUG" tag="${TRAVIS_TAG}" filename="dist/${sha512_file}"
      else
	echo "GITUB_TOKEN unset, skipping upload of ${sha512_file}"      
      fi
    fi
  fi
  if [[ "$TRAVIS_TAG" ]]; then
    if [[ "$GITHUB_TOKEN" ]]; then
      if [[ "$TRAVIS_REPO_SLUG" ]]; then
        #Generate github release edit event 
        ${WDIR}/github-release-event.sh github_api_token=$GITHUB_TOKEN repo_slug="$TRAVIS_REPO_SLUG" tag="${TRAVIS_TAG}"
      fi
    fi
  fi  
else
  echo "error dist directory is missing"
fi





