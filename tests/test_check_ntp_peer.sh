#/bin/sh
check_ntp_peer -H pool.ntp.org -w 10 -c 20  -q > stdout.txt
retval=$?
error=$(cat stdout.txt)
if [[ $retval -eq 0 ]]; then
  exit 0
fi
if [[ $retval -eq 3 ]]; then
  exit 0
fi
if [ "$error" =  "CRITICAL - Socket timeout after 10 seconds" ]; then
  exit 0
fi
echo $error
exit $retval


