#!/bin/bash

pgrep chromium-browse &> /dev/null
if [ $? -eq 0 ]
then
    pkill -9 chromium-browse
fi

sleep 2

export DISPLAY=:0
nohup chromium-browser http://lg1:$2/galaxy?screen=$1 --start-fullscreen 2> /dev/null &

sleep 2

# check if was opened, case not, try to open again
pgrep chromium-browse &> /dev/null
if [ $? -eq 1 ]
then
    nohup chromium-browser http://lg1:$port/galaxy?screen=$screenNumber --start-fullscreen 2> /dev/null &
fi