#!/bin/bash

# MQTT settings
MQTT_BROKER="localhost"
MQTT_PORT=1883
MQTT_USER="emli05"
MQTT_PASS="emli05"
MQTT_SUB="emli05/servo_command"

# Serial port
SERIAL_PORT="/dev/ttyACM0"

while read -r line; do
  # $line is the line read, do something with it
  # which produces $result

  echo "$line"
  if [[ "${line}" =~ \{.*\} ]]; then
    current_angle=$(echo "${line}" | jq .wiper_angle)
    new_angle=$(( 90-$current_angle ))
    echo "{\"wiper_angle\":"$new_angle"}"
    echo "{\"wiper_angle\":"$new_angle"}" > "$SERIAL_PORT"
    echo "new sent was angle: $new_angle"
  fi
  sleep 1
done < "$SERIAL_PORT"
