export PLUGINS="check_http,check_ssh"
export SENSU_GO_ASSET_VERSION="v2.2"
export SENSU_GO_ASSET_FILENAME="monitoring-plugins-${SENSU_GO_ASSET_VERSION}-linux-x86_64.tar.gz"

mkdir -p assets/alpine assets/debian assets/centos

sudo docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-alpine:$SENSU_GO_ASSET_VERSION -f Dockerfile.alpine .
sudo docker run -v "$PWD/assets:/assets" monitoring-plugins-alpine:$SENSU_GO_ASSET_VERSION cp /$SENSU_GO_ASSET_FILENAME /assets/alpine/alpine-$SENSU_GO_ASSET_FILENAME

sudo docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-debian:$SENSU_GO_ASSET_VERSION -f Dockerfile.debian .
sudo docker run -v "$PWD/assets:/assets" monitoring-plugins-debian:$SENSU_GO_ASSET_VERSION cp /$SENSU_GO_ASSET_FILENAME /assets/debian/debian-$SENSU_GO_ASSET_FILENAME

sha512sum assets/alpine/alpine-$SENSU_GO_ASSET_FILENAME
sha512sum assets/debian/debian-$SENSU_GO_ASSET_FILENAME
