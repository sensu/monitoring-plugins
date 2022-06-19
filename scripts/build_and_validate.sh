#!/usr/bin/env bash
[ ! -d "./scripts" ] && echo "Directory ./scripts does not exist" && exit 1
[ ! -d "./builds/enabled" ] && echo "Directory ./builds/enabled does not exist" && exit 1

[ ! -f "./.bonsai.yml" ] && echo "File ./.bonsai.yml does not exist" && exit 1

if [ -z "$PLUGINS" ]
then
      PLUGINS="check_disk,check_dns,check_http,check_load,check_log,check_ntp,check_ntp_peer,check_ntp_time,check_ping,check_procs,check_smtp,check_snmp,check_ssh,check_swap,check_tcp,check_time,check_users,utils.sh"
fi
if [ -z "$ASSET_VERSION" ]
then
  export ASSET_VERSION=$(git describe --abbrev=0 --tags)
fi
if [ -z "$ASSET_REPONAME" ]
then
  export ASSET_REPONAME=monitoring-plugins
fi

if [ -z "$PLATFORMS" ]
then
  OLD_DIR=$(pwd)
  cd builds/enabled
  PLATFORMS=$(find . -maxdepth 1 -mindepth 1 -type d)
  cd $OLD_DIR
fi
echo "PLATFOMRS: $PLATFORMS"

mkdir -p assets/
for platform in $PLATFORMS;
do
  p=$(basename $platform)
  ASSET_FILENAME="${ASSET_REPONAME}-${p}_${ASSET_VERSION}.tar.gz"
  echo "Building: $ASSET_FILENAME"
  if [ -f "./assets/$ASSET_FILENAME" ]; then
    echo "File ${ASSET_FILENAME} already exists in assets dir, skippinng this build"
    continue
  fi
  [ ! -d "./builds/enabled/${p}" ] && echo "Directory /builds/enabled/${p} does not exist" && exit 1
  docker build --no-cache --rm --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$ASSET_VERSION" -t ${ASSET_REPONAME}-${p}:$ASSET_VERSION -f builds/enabled/${p}/Dockerfile .
  docker cp -L $(docker create --rm ${ASSET+REPONAME}-${p}:$ASSET_VERSION true):/$ASSET_FILENAME ./assets/
  [ ! -f "./assets/$i{ASSET_FILENAME}" ] && echo "Error: Asset file ${ASSET_FILENAME} missing from assets directory!" && exit 1 
done

echo -e "\nDone Building, ./assets directory contains:"
find ./assets/ -maxdepth 1 -mindepth 1 -type f

echo -e "\nGenerating checksum file"
cd assets/
CHECKSUMS_FILENAME="${ASSET_REPONAME}_${ASSET_VERSION}_sha512-checksums.txt"
if [[ $(which sha512sum) ]]; then
  sha512sum ./*.tar.gz > $CHECKSUMS_FILENAME;
elif [[ $(which shasum) ]]; then
  shasum -a 512 *.tar.gz > $CHECKSUMS_FILENAME;
fi;
cd $OLD_DIR

echo -e "\nValidating .bonsai.yml asset references"
## Lets validate .bonsai.yml
files=$(grep asset_filename .bonsai.yml | awk -F '"' '{print $2}')
for f in $files
do
  filename=${f/'#{version}'/${ASSET_VERSION}}  
[ ! -f "./assets/${filename}" ] && echo "Error: bonsai asset_filename: ${filename} missing from assets directory!" && exit 1
done
files=$(grep sha_file .bonsai.yml | awk -F '"' '{print $2}')
for f in $files
do
  filename=${f/'#{version}'/${ASSET_VERSION}}  
  filename=${filename/'#{repo}'/${ASSET_REPONAME}}  
  [ ! -f "./assets/${filename}" ] && echo "Error: bonsai sha_file: ${filename} missing from assets directory!" && exit 1
done

echo -e "\nDone Validating .bonsai.yml asset references"



