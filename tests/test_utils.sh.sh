#/bin/sh
source utils.sh
check_range 1 2:8
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


