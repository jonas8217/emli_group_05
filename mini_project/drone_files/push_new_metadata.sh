#!/bin/bash

# get time of push
# Get date in YYYY-MM-DD format and time in HHMMSS
date_and_time=$(date '+%Y-%m-%d %s %H%M%S_%3N')
current_date=$(echo "${date_and_time}" | awk '{print $1}') && current_time=$(echo "${date_and_time}" | awk '{print $3}')

# get drone ID
read -r ID<"/home/anders/Desktop/emli-final/emli_group_05/mini_project/drone_files/drone_id.txt"

cd /home/anders/Desktop/emli-final/annotated_metafiles

# add
git add .

# commit
git commit -m "${current_date} at ${current_time} drone ${ID} offloaded all new metadata"

# push
git push 

# cleanup
