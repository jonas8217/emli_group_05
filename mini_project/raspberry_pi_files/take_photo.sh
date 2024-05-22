#!/bin/bash

# Purpose: Take photo and save to disk in local folder named after date.
# Filename = localTime_ms.
# Safe metadata to JSON file of same name as image

# Get date in YYYY-MM-DD format and time in HHMMSS and get epoch time
date_and_time=$(date '+%Y-%m-%d %s %H%M%S_%3N')
current_date=$(echo "${date_and_time}" | awk '{print $1}') && current_time=$(echo "${date_and_time}" | awk '{print $3}') && epoch_time=$(echo "${date_and_time}" | awk '{print $2}')

# Make directory if not currently there
[ -d "${current_date}" ] || mkdir "${current_date}"

# Take picture
./capture_to_path.sh "${current_date}/${current_time}"

# get important metadata
metadata=$(exiftool -EXIF:ISO -EXIF:ExposureTime -EXIF:SubjectDistance -s3 "${current_date}/${current_time}.jpg")
iso=$(echo "${metadata}" | sed -n 1p) && exposure_time=$(echo "${metadata}" | sed -n 2p) && subject_distance=$(echo "${metadata}" | sed -n 3p)

# Read trigger version
trigger="$1"

# Make JSON file
json_file=$(cat <<EOF
{
	"File Name": "${current_time}",
	"Create Date": "${current_date}",
	"Create Seconds Epoch": "${epoch_time}",
	"Trigger": "${trigger}",
	"Subject Distance": "${subject_distance}",
	"Exposure Time": "${exposure_time}",
	"ISO": "${iso}"
}
EOF
)

# Save file
echo $json_file > "${current_date}/${current_time}".json

# echo path to file
#echo  "${current_date}/${current_time}.jpg"
