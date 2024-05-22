#!/usr/bin/env bash

mosquitto_sub -h localhost -p 1883 -u emli05 -P emli05 -t emli05/wiper_angle |
   while read payload ; do
      echo payload
   done
