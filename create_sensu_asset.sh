#!/bin/bash

BUILD_DIR=/tmp/monitoring-plugins
ASSET_DIR=$BUILD_DIR/assets
mkdir -p $ASSET_DIR

for plugin in $PLUGINS; do
  PKG_DIR=$BUILD_DIR/$plugin
  mkdir -p $PKG_DIR/bin $PKG_DIR/lib $PKG_DIR/include
  cp $plugin $PKG_DIR/bin/
  cp /lib/libssl.so.1.0.0 /usr/lib/libssl.so.1.0.0 $PKG_DIR/lib/
  cp /usr/lib/libintl.so.8 /usr/lib/libintl.so.8.1.5 $PKG_DIR/lib/
  cp /lib/libcrypto.so.1.0.0 /usr/lib/libcrypto.so.1.0.0 /usr/lib/engines/libubsec.so /usr/lib/engines/libatalla.so /usr/lib/engines/libcapi.so /usr/lib/engines/libgost.so /usr/lib/engines/libcswift.so /usr/lib/engines/libchil.so /usr/lib/engines/libgmp.so /usr/lib/engines/libnuron.so /usr/lib/engines/lib4758cca.so /usr/lib/engines/libsureware.so /usr/lib/engines/libpadlock.so /usr/lib/engines/libaep.so $PKG_DIR/lib/
  tar -zcf $ASSET_DIR/$plugin.tar.gz -C $BUILD_DIR/$plugin .
  sha512sum $ASSET_DIR/$plugin.tar.gz
  cp $BUILD_DIR/assets/$plugin.tar.gz /output/
done
