#!/usr/bin/env bash

mosquitto_sub -h localhost -p 1883 -u emli05 -P emli05 -t emli05/ |
   while read payload ; do
      echo "test"
   done
