#!/bin/bash

# MQTT settings
MQTT_BROKER="localhost"
MQTT_PORT=1883
MQTT_USER="emli05"
MQTT_PASS="emli05"
MQTT_SUB="emli05/servo_command"

# Serial port
SERIAL_PORT="/dev/ttyACM0"

exec 3> "$SERIAL_PORT"

# Function to write to the serial port
mqtt_to_serial() {
    mosquitto_sub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" -t "$MQTT_SUB" | 
      while IFS= read -r message; do
        # Write the received message to the serial port
        echo "$message" >&3
	echo "$message"
    done
}

# Example usage: write a test message to the serial port
mqtt_to_serial &

sleep 60
