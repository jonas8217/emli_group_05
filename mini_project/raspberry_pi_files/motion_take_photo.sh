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
	#take image every 2 second
        sleep 2
	# update index 
	if [ "${index}" -eq "1" ]; then
		index="2"
	else
		index="1"
	fi

	# take image
	echo "motion_images/image${index}"
	./capture_to_path.sh "motion_images/image${index}"
	# run motion detector
	python3 motion_detect.py ./motion_images/image1.jpg ./motion_images/image2.jpg
done




