#!/bin/bash

pass="$1"

REPO="https://github.com/LiquidGalaxyLAB/BIM-Liquid-Galaxy-Visualizer"
DEST="/home/lg/projects/BIM-Liquid-Galaxy-Visualizer2"
SERVER_DIR="bim_visualizer_node/"

# remove the directory if exists
if [ -d "$DEST" ]; then rm -Rf $DEST; fi

# clone the repository
git clone $REPO $DEST 2> /dev/null

# move to server directory and execute the install script
(cd $DEST/$SERVER_DIR && git checkout develop && bash install.sh $pass)
