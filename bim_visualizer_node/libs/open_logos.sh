#!/bin/bash

. ${HOME}/etc/shell.conf

for lg in $LG_FRAMES ; do
    sshpass -p $1 ssh -Xnf lg@$lg " sudo -S apt install feh; export DISPLAY=:0; feh -x -g 300x300 /home/lg/logos.png --scale-down --zoom fill </dev/null >/dev/null 2>&1 &" || true
    break
done
