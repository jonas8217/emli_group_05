#!/bin/bash

#subscribe to Mosquitto MQTT trigger topic and take image when pressure plate is pressed
while read topic
do
	./take_photo.sh "External"
done < <(mosquitto_sub -h localhost -p 1883 -u emli05 -P emli05 -t emli05/pressure_plate -v)


