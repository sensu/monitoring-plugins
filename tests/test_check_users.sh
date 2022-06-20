#/bin/sh
check_users -w 1000 -c 10000 > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


