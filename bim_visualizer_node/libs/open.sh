#!/bin/bash

. ${HOME}/etc/shell.conf

port=3210
screenNumber=0;
for lg in $LG_FRAMES ; do
    screenNumber=${lg:2}
    if [ $lg == "lg1" ]; then
        export DISPLAY=:0
        nohup chromium-browser http://lg1:$port/galaxy?screen=$screenNumber --start-fullscreen </dev/null >/dev/null 2>&1 &
    else
        sshpass -p $1 ssh -Xnf lg@$lg " export DISPLAY=:0 ; chromium-browser http://lg1:$port/galaxy?screen=$screenNumber --start-fullscreen </dev/null >/dev/null 2>&1 &" || true
    fi
done

sleep 3

for lg in $LG_FRAMES; do
    sshpass -p $1 ssh -Xnf lg@$lg " export DISPLAY=:0; feh -x -g 300x300 /home/lg/logos.png --scale-down --zoom fill </dev/null >/dev/null 2>&1 &" || true
    break
done

exit 0
