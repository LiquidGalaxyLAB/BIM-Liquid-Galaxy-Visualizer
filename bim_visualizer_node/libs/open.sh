#!/bin/bash
. ${HOME}/etc/shell.conf

port=3210
screenNumber=0;
for lg in $LG_FRAMES ; do
    screenNumber=${lg[@]:2}
    if [ $lg == "lg1" ]; then
        export DISPLAY=:0
        nohup chromium-browser http://lg1:$port/galaxy/$screenNumber --start-fullscreen </dev/null >/dev/null 2>&1 &
    else
        ssh -Xnf lg@$lg " export DISPLAY=:0 ; chromium-browser http://lg1:$port/galaxy/$screenNumber --start-fullscreen </dev/null >/dev/null 2>&1 &" || true
        sleep 3
    fi
done

exit 0
