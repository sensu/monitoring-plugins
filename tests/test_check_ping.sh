#/bin/sh
check_ping -H localhost -w 1,100% -c 2,100% -p 1 > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


