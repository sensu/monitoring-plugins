FROM alpine:latest
ENV \
  PLUGINS="check_http"
RUN apk --update add monitoring-plugins coreutils
ADD create_sensu_asset.sh /build/create_sensu_asset.sh
WORKDIR /usr/lib/monitoring-plugins/
CMD sh /build/create_sensu_asset.sh
