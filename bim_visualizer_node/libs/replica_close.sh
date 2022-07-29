#!/bin/bash

pgrep chromium-browse &> /dev/null
if [ $? -eq 0 ]
then
    pkill -o chromium-browse

    sleep 2

    # check if was closed, case not, try to close again
    pgrep chromium-browse &> /dev/null
    if [ $? -eq 0 ]
    then
        pkill -9 chromium-browse
    fi
fi