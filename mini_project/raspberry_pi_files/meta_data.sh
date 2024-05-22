#!/bin/bash

# get important metadata
# variable 1 = trigger, variable 2 = time, variable 3 = date
metadata=$(exiftool -EXIF:ISO -EXIF:ExposureTime -EXIF:SubjectDistance -s3 "/var/www/html/database/images/$3/$2.jpg")
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
echo $json_file > "/var/www/html/database/images/${current_date}/${current_time}".json




