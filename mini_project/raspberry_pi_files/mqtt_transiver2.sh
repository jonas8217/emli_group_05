#!/bin/bash

# MQTT settings
MQTT_BROKER="localhost"
MQTT_PORT=1883
MQTT_USER="emli05"
MQTT_PASS="emli05"
MQTT_PUB="emli05/wiper_angle"
MQTT_SUB="emli05/servo_command"

# Serial port
SERIAL_PORT="/dev/ttyACM0"

# Open the serial port for reading and writing
exec 3<> "$SERIAL_PORT"

# Function to read from the serial port
read_serial() {
    while IFS= read -t 2 -r line <&3; do
        # remove newlines
        line=$(echo "${line}" | tr -d '[:space:]')
        # Check if the line is in the expected JSON format
        if [[ "$line" =~ ^\{.*\}$ ]]; then
            # Send the line as an MQTT message
            mosquitto_pub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" -t "$MQTT_PUB" -m "$line"
            echo "$line"
        else
            if [[ "$line" != "" ]]; then
                echo "Received invalid JSON: $line"
            fi
        fi
    done
}

# Function to write to the serial port
mqtt_to_serial() {
    mosquitto_sub -h "$MQTT_BROKER" -p "$MQTT_PORT" -u "$MQTT_USER" -P "$MQTT_PASS" -t "$MQTT_TOPIC_SUBSCRIBE" | while IFS= read -r message; do
        # Write the received message to the serial port
        echo "$message" >&3
    done
}

# Example usage: write a test message to the serial port
mqtt_to_serial &

# Start reading from the serial port
read_serial

sleep 10

# Close the serial port
exec 3>&-

