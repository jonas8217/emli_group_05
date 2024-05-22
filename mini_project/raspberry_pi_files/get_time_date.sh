#!/bin/bash

# Get date in YYYY-MM-DD format and time in HHMMSS and get epoch time
date_and_time=$(date '+%Y-%m-%d %s %H%M%S_%3N')
current_date=$(echo "${date_and_time}" | awk '{print $1}') && current_time=$(echo "${date_and_time}" | awk '{print $3}') && epoch_time=$(echo "${date_and_time}" | awk '{print $2}')


echo "${current_date},${current_time},${epoch_time}" 
