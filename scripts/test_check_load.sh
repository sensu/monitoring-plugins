#/bin/sh
check_load -w 100,200,300 -c 400,500,600 --help >> /dev/null
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


