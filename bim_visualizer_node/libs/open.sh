#!/bin/bash

. ${HOME}/etc/shell.conf

port=3210
screenNumber=0;
for lg in $LG_FRAMES ; do
    screenNumber=${lg:2}
    if [ $lg == "lg1" ]; then
        pgrep chromium-browse &> /dev/null
        if [ $? -eq 0 ]
        then
            pkill -9 chromium-browse
        fi

        sleep 2
        
        export DISPLAY=:0
        nohup chromium-browser http://lg1:$port/galaxy?screen=$screenNumber --start-fullscreen 2> /dev/null &
        
        sleep 2

        # check if was opened, case not, try to open again
        pgrep chromium-browse &> /dev/null
        if [ $? -eq 1 ]
        then
            nohup chromium-browser http://lg1:$port/galaxy?screen=$screenNumber --start-fullscreen 2> /dev/null &
        fi
    else
        sshpass -p $1 scp replica_open.sh lg@$lg:/tmp/
        sshpass -p $1 ssh -Xnf lg@$lg " bash /tmp/replica_open.sh $screenNumber $port"
    fi
done

exit 0
