#/bin/sh
check_ntp -H pool.ntp.org -w 10 -c 20 >> /dev/null
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


