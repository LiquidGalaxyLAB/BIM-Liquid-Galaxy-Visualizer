#!/bin/bash

. ${HOME}/etc/shell.conf

pass="$1"

RELAUNCH_CMD="\
if [ -f /etc/init/lxdm.conf ]; then
    export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
    export SERVICE=lightdm
else
    exit 1
fi
if [[ \$(service \$SERVICE status) =~ 'stop' ]]; then
    echo $pass | sudo -S service \${SERVICE} start
else
    echo $pass | sudo -S service \${SERVICE} restart
fi
"

lg_current="$(hostname)"

for lg in $LG_FRAMES; do
    if [ $lg != $lg_current ]; then
        sshpass -p $pass ssh -t -x lg@$lg "$RELAUNCH_CMD"
    fi
done

sshpass -p $pass ssh -t -x lg@$lg_current "$RELAUNCH_CMD"