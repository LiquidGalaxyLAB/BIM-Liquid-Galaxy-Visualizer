#!/bin/bash

. ${HOME}/etc/shell.conf

ROTATION=$1
ACTUALSCREEN=0

for lg in $LG_FRAMES ; do
    ACTUALSCREEN=$(echo "$lg" | cut -c3)
    if [ $ACTUALSCREEN == 1 ]; then
        export DISPLAY=:0
        xrandr -o $ROTATION
    else
        ssh -Xnf lg@$lg " export DISPLAY=:0 ; xrandr -o $ROTATION "
    fi
    sleep 0.5
done  

exit 0