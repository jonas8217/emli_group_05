#!/bin/bash

# Purpose: Take photo and save to disk in local folder named after date.
# Filename = localTime_ms.
# Safe metadata to JSON file of same name as image

# Get date in YYYY-MM-DD format and time in HHMMSS
date_and_time=$(date '+%Y-%m-%d %H%M%S_%3N') && epoch_time=$(date '+%s')

# make directory if not currently there
mkdir "${date_and_time%% *}"

# Take picture
rpicam-still -t 0.01 -o "${date_and_time%% *}/${date_and_time##* }".jpg

# Make JSON file
json_file=$(cat <<EOF
{
	"File Name": "${date_and_time##* }",
	"Create Date": "${date_and_time%% *}",
	"Create Seconds Epoch": "${epoch_time}",
	"Trigger": "poop4",
	"Subject Distance": "poop5",
	"Exposure Time": "poop6",
	"ISO": "poop7"
}
EOF
)

# Save file
echo $json_file > "${date_and_time%% *}/${date_and_time##* }".json

