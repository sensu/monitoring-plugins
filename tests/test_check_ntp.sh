#/bin/sh
check_ntp -H pool.ntp.org -w 10 -c 20 >> /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


