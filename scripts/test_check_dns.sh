#/bin/sh
check_dns --help
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


