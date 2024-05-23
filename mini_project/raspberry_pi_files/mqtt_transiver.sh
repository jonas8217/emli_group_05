# Read from the serial port line by line

mosquitto_sub -h localhost -p 1883 -u emli05 -P emli05 -t emli05/wiper_angle |
  while read payload; do
    # send wiper angle to pico
    echo "${payload}" > /dev/ttyACM0
    stdbuf -oL cat "$SERIAL_PORT" | while IFS= read -t 0.1 -r line; do
    #line=$(stdbuf -oL cat /dev/ttyACM0)
    line=$(echo "${line}" | tr -d '[:space:]')
    # Check if the line is in the expected JSON format
    if [[ "$line" =~ \{.*\} ]]; then
      # Send the line as an MQTT message
      mosquitto_pub -h localhost -p 1883 -u emli05 -P emli05 -t emli05/wiper_angle -m "$line"
    #else
      #if [[ "${line}" != "\n" ]]; then
      #    #echo "Received invalid JSON: ${line}"
      #fi
    fi

  done
