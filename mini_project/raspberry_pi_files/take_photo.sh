#!/bin/bash

# Purpose: Take photo and save to disk in local folder named after date.
# Filename = localTime_ms.
# Safe metadata to JSON file of same name as image

# Get date in YYYY-MM-DD format and time in HHMMSS
date_and_time=$(date '+%Y-%m-%d %H%M%S_%3N')

# make directory if not currently there
mkdir "${date_and_time%% *}"

# Take picture
rpicam-still -t 0.01 -o "${date_and_time%% *}/${date_and_time##* }".jpg

