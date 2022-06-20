#!/bin/bash
echo "  Testing Parameters:"
echo "    Asset Build:  ${platform}"
echo "    Target Platform: ${test_platform}"
echo "    Asset Tarball:   ${asset_filename}"
echo "    Plugin Tests: ${plugins}"
#tests=${plugins//hmm/h }
if [ -z "$asset_filename" ]; then
  echo "Asset is empty"
  exit 1
fi
#mkdir -p /build
#cd /build
#tar xzf /dist/$asset_filename
export LD_LIBRARY_PATH="/build/lib:$LD_LIBRARY_PATH" 
export PATH="/build/bin/:$PATH"
while IFS=',' read -ra tests; do
  for t in "${tests[@]}"; do
    echo "      Running: /tests/test_${t}.sh"
    /tests/test_${t}.sh
    retval=$?
    if [ $retval -ne 0 ]; then
        echo "!!! Test error: test_${t}.sh"
        exit $retval
    fi

  done
done <<< "$plugins"


