#!/bin/bash

. ${HOME}/etc/shell.conf

for lg in $LG_FRAMES ; do
    sshpass -p $1 ssh -Xnf lg@$lg " sudo -S apt install feh; export DISPLAY=:0; feh -x -g 700x700 /home/lg/logos.png --zoom fill </dev/null >/dev/null 2>&1 &" || true
    break
done
