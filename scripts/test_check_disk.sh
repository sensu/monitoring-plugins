#/bin/sh
check_disk -w 1% -c 1% -e -l
retval=$?
exit $retval


