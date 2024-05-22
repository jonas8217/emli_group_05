#!/bin/bash

# Take picture every time 5 minutes have passed
while true
do
	./take_photo.sh "Time" &
	sleep 300
done
