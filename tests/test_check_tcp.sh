#/bin/sh
check_tcp -H www.sensu.io -p 80 > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


