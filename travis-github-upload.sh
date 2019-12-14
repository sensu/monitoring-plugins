#!/usr/bin/env bash
##
# Adapted from sensu/sensu-go-bonsai-asset repo
##

[[ -z "$WDIR" ]] && { echo "WDIR is empty using bonsai/" ; WDIR="bonsai/"; }

##
# TravisCI specific asset build script.
#   Uses several TravisCI specific environment variables 
##
[[ -z "$GITHUB_TOKEN" ]] && { echo "GITHUB_TOKEN is empty, upload disabled" ; }
[[ -z "$TRAVIS_REPO_SLUG" ]] && { echo "TRAVIS_REPO_SLUG is empty"; exit 1; }
TAG=$TRAVIS_TAG
CURRENT_COMMIT=$(git rev-parse HEAD)
[[ -z "$TAG" ]] && { echo "TRAVIS_TAG is empty" ; TAG="0.0.1"; }
[[ -z "$TRAVIS_COMMIT" ]] && { echo "TRAVIS_COMMIT is empty, using current commit" ; TRAVIS_COMMIT=$CURRENT_COMMIT; }

GIT_REPO="https://github.com/${TRAVIS_REPO_SLUG}.git"
GIT_REF=${TRAVIS_COMMIT}

if [ -d dist ]; then
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

  #  JDS Commenting out the automaatic package logic here for now
  #IFS=_ read -r package leftover <<< "$file"
  #unset leftover
  package="monitoring-plugins"
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





