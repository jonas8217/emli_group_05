#!/usr/bin/env bash

MQTT_BROKER="localhost"
MQTT_PORT=1883
MQTT_USER="emli05"
MQTT_PASS="emli05"
MQTT_PUB="emli05/servo_command"
MQTT_SUB="emli05/wiper_and_rain"


pub () {
  mosquitto_pub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" -t "$MQTT_PUB" -m "$1"
}


# reset to 0 position
pub "0"

logged=false

while true; do
  rain=$(mosquitto_sub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" -t "$MQTT_SUB" -R -C 1 | 
    (read wiper_angle rain; echo $rain)
  )
  if [[ "${rain}" == "1" ]]; then
    if [[ $logged == false ]]; then
      ./append_log.sh "rain fall detectet"
      logged=true
    fi

    sleep 1
    pub "180"
    sleep 1
    pub "0"
  else
    logged=false
  fi
done
