#/bin/sh
check_ssh --help > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


