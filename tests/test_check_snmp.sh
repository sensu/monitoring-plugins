#/bin/sh
check_snmp -H snmp.live.gambitcommunications.com -o sysContact.0 > /dev/null
retval=$?
if [[ $retval -eq 3 ]]; then
  exit 0
fi
exit $retval


