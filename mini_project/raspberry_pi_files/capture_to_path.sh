#!/bin/bash

# Take picture and save to path
rpicam-still -v0 -t 0.01 -o "$1".jpg
