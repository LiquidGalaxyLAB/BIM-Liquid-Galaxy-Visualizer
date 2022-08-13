#!/bin/bash

. ${HOME}/etc/shell.conf

lg_current="$(hostname)"
	
for lg in $LG_FRAMES; do
	if [ "$lg" != "$lg_current" ]; then
		sshpass -p $1 ssh -t -x root@$lg " sudo -S poweroff";
	fi
done

sshpass -p $1 ssh -t -x root@${lg_current} " sudo -S poweroff"

exit 0