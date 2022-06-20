#/bin/sh
check_smtp -H smtp.gmail.com > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


