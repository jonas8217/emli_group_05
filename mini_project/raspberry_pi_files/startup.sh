#!/bin/bash
cd /home/emli/emli_group_05/mini_project/raspberry_pi_files/
./motion_take_photo.sh&
./external_take_photo.sh&
./time_take_photo.sh&
./lens_wiper.sh&
python mqtt_transceiver.py
