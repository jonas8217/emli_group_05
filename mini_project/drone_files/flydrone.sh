#!/bin/bash

SSID_TO_FIND='EMLI-TEAM-05-2.4'
REMOTE_USER='emli'
REMOTE_PASSWORD='05050505'
REMOTE_IP='192.168.10.1'
REMOTE_FOLDER='/var/www/html/database/images'
LOCAL_FOLDER='emli_group_05/mini_project/drone_files/temp'
# get drone ID
read -r ID<"/home/anders/Desktop/emli-final/emli_group_05/mini_project/drone_files/drone_id.txt"
Drone_ID=${ID}
WIFI_INTERFACE=wlp3s0
SPECIFIC_KEY="Drone ID"

# Function to scan Wi-Fi networks
scan_wifi() {
    iwlist $WIFI_INTERFACE scan | grep ESSID
}

# Function to check if SSID is found
ssid_found() {
    local scan_output="$1"
    echo "$scan_output" | grep -q "$SSID_TO_FIND"
}

# Function to copy a file via SCP
copy_file_via_scp() {
    local remote_path="$1"
    local local_path="$2"
    scp -o StrictHostKeyChecking=no "${REMOTE_USER}@${REMOTE_IP}:${remote_path}" "${local_path}"
}

# Post to SQL DB
WIFI_log() {
    #echo "Logging Wifi" 
    ./emli_group_05/mini_project/drone_files/wifi_logger.sh
}

# Function to copy files with specific key
copy_files_with_specific_key() {
    # Find all JSON files in the remote folder and its subdirectories
    sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "${REMOTE_USER}@${REMOTE_IP}" "
        find ${REMOTE_FOLDER} -type f -name '*.json'
    " | while read -r remote_json_file; do
        # Copy the JSON file to the local folder
        remote_json_filename=$(basename "$remote_json_file")
        local_json_file="${LOCAL_FOLDER}/${remote_json_filename}"
        copy_file_via_scp "$remote_json_file" "$local_json_file"
        
        # Write signal quality measures to SQL database
        WIFI_log

        # Extract the value of the Drone ID key using jq
        value=$(jq -r '.["Drone ID"]' "$local_json_file")

        # Check if the key is set and not empty
        if [[ -n "$value" ]]; then
        echo "The key '$SPECIFIC_KEY' of '$local_json_file' is set and not empty. Value: $value"
        
        # If set, just remove and move on
        rm $local_json_file

        else
        echo "The key '$SPECIFIC_KEY' of '$local_json_file' is either not set or is empty."

        # If not already copied, get the jpg, change the .json and synchrnize .json
        # The file paths for .jpg's
        remote_jpg_file="${remote_json_file%.json}.jpg"
        local_jpg_file="${LOCAL_FOLDER}/${remote_png_file##*/}"

        copy_file_via_scp "$remote_jpg_file" "$local_jpg_file"

        # Modify the JSON file to set the "Drone ID" key
        jq --arg new_value "$Drone_ID" '.["Drone ID"]=$new_value' "$local_json_file" > tmpfile && mv tmpfile "$local_json_file"
        # And "seconds_epochs" key
        timestamp=$(date +%s)
        jq --arg epoch "$timestamp" '. + {seconds_epochs: $epoch}' "$local_json_file" > "${local_json_file}.tmp" && mv "${local_json_file}.tmp" "$local_json_file"

        # Send modified JSON back
        scp -o StrictHostKeyChecking=no "$local_json_file" "${REMOTE_USER}@${REMOTE_IP}:${remote_json_file}"

        fi
    done

    # Move all new images and their .json's to the permanent storage folder pre AI
    mv "$LOCAL_FOLDER"/* "emli_group_05/mini_project/drone_files/images"/
}

while true; do
    echo "Scanning for Wi-Fi networks..."
    wifi_scan_output=$(scan_wifi)


    if ssid_found "$wifi_scan_output"; then
        echo "Found SSID ${SSID_TO_FIND}. Connecting and copying files..."

        
        connected_ssid=$(nmcli -t -f NAME,DEVICE con show --active | grep "$SSID_TO_FIND" | cut -d: -f1)
        if [ "$connected_ssid" == "$SSID_TO_FIND" ]; then

        # If connected to WildCam Wifi
        echo "Connected to '$SSID_TO_FIND', beginning copying."

        # Synch time
        time=$(date +%s)
        sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "${REMOTE_USER}@${REMOTE_IP}" "./emli_group_05/mini_project/raspberry_pi_files/update_time.sh ${time}"
        
        # Write signal quality measures to SQL database
        WIFI_log

        # Extract image and synchronize
        {
            sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "${REMOTE_USER}@${REMOTE_IP}" "exit"
            copy_files_with_specific_key
            echo "Files copied and modified successfully."
        } || {
            echo "An error occurred during SSH or SCP operations."
        }

        else

        # Try to connect
        #echo "Connecting to '$wifi_ssid'."

        # Disconnect from any active WiFi connection
        nmcli con down id "$connected_ssid" >/dev/null 2>&1

        # Connect to the specified WiFi network
        nmcli dev wifi connect "$wifi_ssid" password "$wifi_password"
        fi
        
    else
        # Wait 30 seconds until testing whether within WIFI range of wild cam again
        echo "SSID ${SSID_TO_FIND} not found. Retrying in 30 seconds..."
        sleep 30 
    fi
    sleep 5
    break
done
