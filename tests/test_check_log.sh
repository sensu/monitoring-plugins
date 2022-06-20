#/bin/sh
echo "This is a test of the emergency broadcast system" > /test_log.txt
check_log -F /test_log.txt -O /old_test_log.txt -q "This is a test" > stdout.txt 2>stderr.txt

retval=$?

error=$(cat stderr.txt)
if [ $retval -ne 0 ]
then
  cat stdout.txt
  
fi
if [ ! -z "$error" ]
then
      echo "check_log stderr is NOT empty"
      echo $error
      if [ "$error" = "/build/bin/check_log: line 191: diff: command not found" ]; then
        exit 0
      fi
      exit 1
fi
exit $retval
