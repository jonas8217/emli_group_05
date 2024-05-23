#!/bin/bash

# update date using epoch time
date_and_time=$(date --date="@$1")
date -s "${date_and_time}"
