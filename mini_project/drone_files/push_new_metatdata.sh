#!/bin/bash

# get time of push
# Get date in YYYY-MM-DD format and time in HHMMSS
date_and_time=$(date '+%Y-%m-%d %s %H%M%S_%3N')
current_date=$(echo "${date_and_time}" | awk '{print $1}') && current_time=$(echo "${date_and_time}" | awk '{print $3}')

# get drone ID
read -r ID<"drone_id.txt"

# add
git add -A

# commit
git commit -m "${current_date} at ${current_time} drone ${ID} offloaded all new metadata"

# push
git push origin meta_files

# cleanup
