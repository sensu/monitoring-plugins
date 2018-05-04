#!/bin/bash

BUILD_DIR=/build/monitoring-plugins

mkdir -p $BUILD_DIR/assets

for plugin in $PLUGINS; do
  mkdir -p $BUILD_DIR/$plugin/bin $BUILD_DIR/$plugin/lib $BUILD_DIR/$plugin/include
  cp $plugin $BUILD_DIR/$plugin/bin/
  tar -zcf $BUILD_DIR/assets/$plugin.tar.gz -C $BUILD_DIR/$plugin .
  sha512sum $BUILD_DIR/assets/$plugin.tar.gz
  cp $BUILD_DIR/assets/$plugin.tar.gz /output/
done
