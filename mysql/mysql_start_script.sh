#!/bin/sh
#

docker-entrypoint.sh mysqld

counter=0
limit=60
interval=10

while true
do
#Connection Test Command
exec 3> /dev/tcp/localhost/3306 > /dev/null
if [ $? = 0 ]; then
  #Service is up, inform steakholders!
  echo "          MYSQL IS READY NOW,  LET US GIVE GRANT"
  mysql --user root --password=admin --database journals --execute="grant all privileges on *.* to 'root'@'%' identified by 'admin' with grant option"
elif [[ "$counter" -gt "$limit" ]]; then
  #Opsss...There is a problem!
  echo "          Counter: $counter times reached; THERE MUST BE A PROBLEM IN MYSQL, Please check it!!!"
  exit 1
else
  #Try one more time in limit interval
  echo "          MYSQL IS NOT READY, IT WILL BE TRIED ONE MORE TIME IN '$interval' SECONDS !!!!!!!!!"
  counter=$((counter+1))
  sleep $interval
fi
done

mysql --user root --password=admin --database journals --execute="grant all privileges on *.* to 'root'@'%' identified by 'admin' with grant option"