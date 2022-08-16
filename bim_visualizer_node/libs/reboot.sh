#!/bin/bash

. ${HOME}/etc/shell.conf

pass="$1"
lg_current="$(hostname)"

for lg in $LG_FRAMES; do
    if [ $lg != $lg_current ]; then
        sshpass -p $pass ssh -t -x lg@$lg "echo $pass | sudo -S reboot"
    fi
done

sshpass -p $pass ssh -t -x lg@$lg_current "echo $pass | sudo -S reboot"

exit 0