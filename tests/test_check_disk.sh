#/bin/sh
check_disk -w 0 -c 0 -e -l > /dev/null
retval=$?
exit $retval


