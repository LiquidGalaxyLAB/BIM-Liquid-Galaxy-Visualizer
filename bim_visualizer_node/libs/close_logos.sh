#!/bin/bash

. ${HOME}/etc/shell.conf

for lg in $LG_FRAMES ; do
    sshpass -p $1 ssh -Xnf lg@$lg " pkill feh </dev/null >/dev/null 2>&1 &" || true
    break
done
