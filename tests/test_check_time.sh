#/bin/sh
check_time -H Ntp-wwv.nist.gov > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


