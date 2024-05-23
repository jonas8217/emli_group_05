#!/bin/bash

# get important metadata
# variable 1 = trigger, variable 2 = time, variable 3 = date, variable 4 = epoch
metadata=$(exiftool -EXIF:ISO -EXIF:ExposureTime -EXIF:SubjectDistance -s3 "/var/www/html/database/images/$3/$2.jpg")
iso=$(echo "${metadata}" | sed -n 1p) && exposure_time=$(echo "${metadata}" | sed -n 2p) && subject_distance=$(echo "${metadata}" | sed -n 3p | sed 's/.$//')
# read camera ID
read -r ID<"/var/www/html/database/camera_id.txt"

# Make JSON file
json_file=$(cat <<EOF
{
        "File Name": "$2",
        "Create Date": "$3",
        "Create Seconds Epoch": "$4",
        "Trigger": "$1",
        "Subject Distance": "${subject_distance}",
        "Exposure Time": "${exposure_time}",
        "ISO": "${iso}",
	"Camera ID" : "${ID}",
	"Drone ID" : ""
}
EOF
)

# Save file
echo $json_file > "/var/www/html/database/images/$3/$2".json



