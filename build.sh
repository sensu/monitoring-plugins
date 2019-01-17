export PLUGINS="check_http,check_ssh"
export SENSU_GO_ASSET_VERSION="v2.2"

mkdir -p assets/alpine assets/debian assets/centos

export SENSU_GO_ASSET_FILENAME="monitoring-plugins-alpine-${SENSU_GO_ASSET_VERSION}-linux-x86_64.tar.gz"
sudo docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-alpine:$SENSU_GO_ASSET_VERSION -f Dockerfile.alpine .
sudo docker run -v "$PWD/assets:/assets" monitoring-plugins-alpine:$SENSU_GO_ASSET_VERSION cp /$SENSU_GO_ASSET_FILENAME /assets/alpine/$SENSU_GO_ASSET_FILENAME

export SENSU_GO_ASSET_FILENAME="monitoring-plugins-debian-${SENSU_GO_ASSET_VERSION}-linux-x86_64.tar.gz"
sudo docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-debian:$SENSU_GO_ASSET_VERSION -f Dockerfile.debian .
sudo docker run -v "$PWD/assets:/assets" monitoring-plugins-debian:$SENSU_GO_ASSET_VERSION cp /$SENSU_GO_ASSET_FILENAME /assets/debian/$SENSU_GO_ASSET_FILENAME

sha512sum assets/**/*.tar.gz
