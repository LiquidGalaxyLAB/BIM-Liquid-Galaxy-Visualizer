#!/bin/bash
. ${HOME}/etc/shell.conf

port=3210;
screenNumber=0;
for lg in $LG_FRAMES ; do
    screenNumber=${lg:2}
	if [ $lg == "lg1" ]; then
        ssh -Xnf lg@$lg " export DISPLAY=:0 ; chromium-browser http://localhost:$port/$screenNumber --start-fullscreen --autoplay-policy=no-user-gesture-required 2> /dev/null" || true
	else
        ssh -Xnf lg@$lg " export DISPLAY=:0 ; chromium-browser http://lg1:$port/$screenNumber --start-fullscreen 2> /dev/null" || true
	fi

   sleep 1
done

exit 0
