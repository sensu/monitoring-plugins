#/bin/sh
check_http -w 5 -c 10 -H www.sensu.io > /dev/null
retval=$?
exit $retval


