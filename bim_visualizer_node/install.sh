#!/bin/bash

# Create logs directory if it doesnt exist yet
mkdir -p ./logs

# Create file name with name as date
date=$(date +%m-%d-%y)
filename="$date.txt"

# Add to log with timestamp
time=$(date +%H:%M:%S)
echo "[$time] Installing Galaxy BIM Visualizer..." | tee -a ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installing new packages..." | tee -a ./logs/$filename
sudo apt-get install -yq chromium-browser sshpass npm > ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installing node..." | tee -a ./logs/$filename
sudo npm install -g n > /dev/null 2>> ./logs/$filename
sudo n stable > /dev/null

# Open port 3210

LINE=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | awk -F " -j" '{print $1}'`

RESULT=$LINE",3210"

DATA=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | grep "3210"`

if [ "$DATA" == "" ]; then
  time=$(date +%H:%M:%S)
  echo "[$time] Port 3210 not open, opening port..." | tee -a ./logs/$filename
  sudo sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf 2>> ./logs/$filename
else
  time=$(date +%H:%M:%S)
  echo "[$time] Port 3210 already open." | tee -a ./logs/$filename
fi

# Open port 3220

LINE=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | awk -F " -j" '{print $1}'`

RESULT=$LINE",3220"

DATA=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | grep "3220"`

if [ "$DATA" == "" ]; then
  time=$(date +%H:%M:%S)
  echo "[$time] Port 3220 not open, opening port..." | tee -a ./logs/$filename
  sudo sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf 2>> ./logs/$filename
else
  time=$(date +%H:%M:%S)
  echo "[$time] Port 3220 already open." | tee -a ./logs/$filename
fi

# Install dependencies
time=$(date +%H:%M:%S)
echo "[$time] Installing server dependencies..." | tee -a ./logs/$filename
npm install 2>> ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installation complete. Reboot machine to finish installation" | tee -a ./logs/$filename

read -p "Do you want to reboot your machine now? [Y/n]: " yes

if [[ $yes =~ ^[Yy]$ ]]
then
  sudo reboot
fi