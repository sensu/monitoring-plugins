#!/bin/bash
echo "Test Script:"
echo "  Asset Platform:  ${platform}"
echo "  Target Platform: ${test_platform}"
echo "  Asset Tarball:   ${asset_filename}"
echo "  Plugin Tests: ${plugins}"
#tests=${plugins//hmm/h }
if [ -z "$asset_filename" ]; then
  echo "Asset is empty"
  exit 1
fi
mkdir -p /build
cd /build
tar xzf /dist/$asset_filename
LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" 
PATH="/build/bin/:$PATH"
while IFS=',' read -ra tests; do
  for t in "${tests[@]}"; do
    /scripts/test_${t}.sh
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "!!! Test error: test_${t}.sh"
        exit $retval
    fi

  done
done <<< "$plugins"


