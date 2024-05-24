#!/bin/bash

# Make lof file if not currently there
[ -f "/var/www/html/database/log.txt" ] || touch "/var/www/html/database/log.txt}"

# if no date and time is given then get that and write to file else write to file with given date
if [ -z "$2" ]; then
	IFS=, read -r current_date current_time epoch_time <<<$(./get_time_date.sh)
else
	current_date="$2"
	current_time="$3"
fi

# make trigger message
message="$1"
if [ "${message}" == "External" ]; then
	echo "${current_date} ${current_time} : Pressure plate trigered" >> /var/www/html/database/log.txt
elif [ "{$message}" == "Motion" ]; then
	echo "${current_date} ${current_time} : Motion detected" >> /var/www/html/database/log.txt
elif [ "${message}" == "Time" ]; then
	echo "${current_date} ${current_time} : 5 minutes passed. An image have been taken" >> /var/www/html/database/log.txt
else
	echo "${current_date} ${current_time} : ${message}" >> /var/www/html/database/log.txt 
fi




