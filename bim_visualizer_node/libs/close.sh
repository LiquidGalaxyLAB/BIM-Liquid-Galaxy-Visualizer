#!/bin/bash

. ${HOME}/etc/shell.conf

for lg in $LG_FRAMES ; do
	if [ $lg == "lg1" ]; then
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
	else
		sshpass -p $1 scp replica_close.sh lg@$lg:/tmp/
    	sshpass -p $1 ssh -Xnf lg@$lg " bash /tmp/replica_close.sh"
	fi
done

exit 0