#!/bin/bash

. ${HOME}/etc/shell.conf

for lg in $LG_FRAMES ; do
	if [ $lg == "lg1" ]; then
		pkill -o chromium-browse
		pkill -o chrome
	else
		sshpass -p $1 ssh -Xnf lg@$lg " pkill -o chromium-browse; pkill -o chrome" 2> /dev/null || true
	fi
done

for lg in $LG_FRAMES; do
    sshpass -p $1 ssh -Xnf lg@$lg " pkill feh"
    break
done

exit 0
