export PLUGINS="check_disk,check_http,check_ntp,check_ntp_peer,check_ntp_time,check_ping,check_procs,check_smtp,check_ssh,check_swap,check_tcp,check_time,check_users"
export SENSU_GO_ASSET_VERSION="v2.2"

for PLATFORM in alpine debian centos;
do
  mkdir -p assets/$PLATFORM
  export SENSU_GO_ASSET_FILENAME="monitoring-plugins-${PLATFORM}-${SENSU_GO_ASSET_VERSION}-linux-x86_64.tar.gz"
  docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-${PLATFORM}:$SENSU_GO_ASSET_VERSION -f Dockerfile.${PLATFORM} .
  docker cp -L $(docker create monitoring-plugins-${PLATFORM}:$SENSU_GO_ASSET_VERSION true):/$SENSU_GO_ASSET_FILENAME ./assets/${PLATFORM}/
  shasum -a 512 assets/${PLATFORM}/*.tar.gz
done;

# export SENSU_GO_ASSET_FILENAME="monitoring-plugins-debian-${SENSU_GO_ASSET_VERSION}-linux-x86_64.tar.gz"
# docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-debian:$SENSU_GO_ASSET_VERSION -f Dockerfile.debian .
# docker cp -L $(docker create --rm monitoring-plugins-debian:$SENSU_GO_ASSET_VERSION true):/$SENSU_GO_ASSET_FILENAME /assets/debian/$SENSU_GO_ASSET_FILENAME
#
# export SENSU_GO_ASSET_FILENAME="monitoring-plugins-centos-${SENSU_GO_ASSET_VERSION}-linux-x86_64.tar.gz"
# docker build --build-arg "PLUGINS=$PLUGINS" --build-arg "SENSU_GO_ASSET_VERSION=$SENSU_GO_ASSET_VERSION" -t monitoring-plugins-centos:$SENSU_GO_ASSET_VERSION -f Dockerfile.centos .
# docker cp -L $(docker create --rm monitoring-plugins-centos:$SENSU_GO_ASSET_VERSION true):/$SENSU_GO_ASSET_FILENAME /assets/centos/$SENSU_GO_ASSET_FILENAME
#
# sha512sum assets/**/*.tar.gz
