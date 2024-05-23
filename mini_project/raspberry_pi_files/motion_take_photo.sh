#!/bin/bash

# Make directory if not currently there
[ -d "motion_images" ] || mkdir "motion_images"

# initialize index
index="1"

# take initial picture
./capture_to_path.sh motion_images/image1

# loop forever
while true
do
	#take image every 1 second
        sleep 1
	# update index 
	if [ "${index}" -eq "1" ]; then
		index="2"
	else
		index="1"
	fi
	# get time, date and epoch
	IFS=, read -r current_date current_time epoch_time <<<$(./get_time_date.sh)
	# take image
	./capture_to_path.sh "motion_images/image${index}"
	# run motion detector
	motion=$(python3 motion_detect.py ./motion_images/image1.jpg ./motion_images/image2.jpg)
	echo "${motion}"
	# move and rename new image if motion
	if [ "${motion}" == "Motion detected" ]; then
		cp "motion_images/image${index}.jpg" "/var/www/html/database/images/${current_date}/${current_time}.jpg"		
		# Create metadata
		./meta_data.sh "motion" "${current_time}" "${current_date}" "${epoch_time}"
		# store event in log
		./append_log.sh "motion" "${current_date}" "${current_time}"

	fi
done




