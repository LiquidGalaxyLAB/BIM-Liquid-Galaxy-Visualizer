#!/bin/bash
. ${HOME}/etc/shell.conf

port=$1
screenNumber=0;
for lg in $LG_FRAMES ; do
    screenNumber=${lg[@]:2}
    if [ $lg == "lg1" ]; then
        export DISPLAY=:0
        nohup chromium-browser http://lg1:$port/$screenNumber --start-fullscreen 2> /dev/null
    else
        ssh -Xnf lg@$lg " export DISPLAY=:0 ; chromium-browser http://lg1:$port/$screenNumber --start-fullscreen 2> /dev/null" || true
    fi
done

exit 0