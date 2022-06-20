#/bin/sh
check_swap  -w 1 -c 1 > /dev/null
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


