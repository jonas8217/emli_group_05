#!/bin/bash

# Purpose: Take photo and save to disk in local folder named after date.
# Filename = localTime_ms.
# Safe metadata to JSON file of same name as image

# Get date in YYYY-MM-DD format and time in HHMMSS and get epoch time
IFS=, read -r current_date current_time epoch_time <<<$(./get_time_date.sh)

# Make directory if not currently there
[ -d "/var/www/html/database/images/${current_date}" ] || mkdir -p "/var/www/html/database/images/${current_date}"

# Take picture
./capture_to_path.sh "/var/www/html/database/images/${current_date}/${current_time}"

# Read trigger version
trigger="$1"

# Create metadata
./meta_data.sh "${trigger}" "${current_time}" "${current_date}" "${epoch_time}"

# store event in log
./append_log.sh "${trigger}" "${current_date}" "${current_time}"
 
