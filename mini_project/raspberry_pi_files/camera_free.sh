#!/bin/bash

# wait until camera is free
free=$(ps aux | grep -i "capture_to_path.sh" | grep -v "grep" | wc -l)
while [ "${free}" -ge "1" ]; do
	free=$(ps aux | grep -i "capture_to_path.sh" | grep -v "grep" | wc -l)
	sleep 0.01
done

exit 0
