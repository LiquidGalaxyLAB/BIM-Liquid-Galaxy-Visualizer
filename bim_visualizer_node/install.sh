#!/bin/bash

. ${HOME}/etc/shell.conf

pass="$1"

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
echo $pass | sudo -S apt-get install -yq npm > ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installing node..." | tee -a ./logs/$filename
echo $pass | sudo -S npm install -g n > /dev/null 2>> ./logs/$filename
echo $pass | sudo -S n stable > /dev/null

time=$(date +%H:%M:%S)
echo "[$time] Installing local tunnel..." | tee -a ./logs/$filename
echo $pass | sudo -S npm install -g localtunnel > /dev/null 2>> ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installing slave dependencies..." | tee -a ./logs/$filename
for lg in $LG_FRAMES ; do
  sshpass -p $pass scp public/logos.png $lg:/home/lg/
  sshpass -p $pass ssh lg@$lg "echo $pass | sudo -S apt-get install -yq feh"
  break
done

# Open port 3210

LINE=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | awk -F " -j" '{print $1}'`

RESULT=$LINE",3210"

DATA=`cat /etc/iptables.conf | grep "tcp" | grep "8111" | grep "3210"`

if [ "$DATA" == "" ]; then
  time=$(date +%H:%M:%S)
  echo "[$time] Port 3210 not open, opening port..." | tee -a ./logs/$filename
  echo $pass | sudo -S sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf 2>> ./logs/$filename
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
  echo $pass | sudo -S sed -i "s/$LINE/$RESULT/g" /etc/iptables.conf 2>> ./logs/$filename
else
  time=$(date +%H:%M:%S)
  echo "[$time] Port 3220 already open." | tee -a ./logs/$filename
fi

# Creating systemd server and socket services

time=$(date +%H:%M:%S)
echo "[$time] Creating server daemon..." | tee -a ./logs/$filename
SERVICE_NAME=bimlgvisualizer-server
IS_ACTIVE=$(sudo systemctl is-active $SERVICE_NAME)
if [ "$IS_ACTIVE" == "active" ]; then
  echo "Service $SERVICE_NAME is running" | tee -a ./logs/$filename
  echo "Restarting service" | tee -a ./logs/$filename
  echo $pass | sudo -S systemctl restart $SERVICE_NAME
  echo "Service restarted" | tee -a ./logs/$filename
else
  echo "Creating service $SERVICE_NAME"

  echo $pass | sudo -S tee /etc/systemd/system/${SERVICE_NAME//'"'/}.service > /dev/null << EOM
[Unit]
Description=Localtunnel Daemon
After=syslog.target network.target

[Service]
# Change the user variable here according to your needs
User=root

Type=simple

ExecStart=/usr/local/bin/lt --subdomain bimlgvisualizer-server --port 3210
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOM

  # restart daemon, enable and start service
  echo "Reloading daemon and enabling service" | tee -a ./logs/$filename
  echo $pass | sudo -S systemctl daemon-reload 
  echo $pass | sudo -S systemctl enable ${SERVICE_NAME//'.service'/} # remove the extension
  echo $pass | sudo -S systemctl start ${SERVICE_NAME//'.service'/}
  echo "Service $SERVICE_NAME Started" | tee -a ./logs/$filename
fi

time=$(date +%H:%M:%S)
echo "[$time] Creating socket daemon..." | tee -a ./logs/$filename
SERVICE_NAME=bimlgvisualizer-socket
IS_ACTIVE=$(sudo systemctl is-active $SERVICE_NAME)
if [ "$IS_ACTIVE" == "active" ]; then
  echo "Service $SERVICE_NAME is running" | tee -a ./logs/$filename
  echo "Restarting service" | tee -a ./logs/$filename
  echo $pass | sudo -S systemctl restart $SERVICE_NAME
  echo "Service restarted" | tee -a ./logs/$filename
else
  echo "Creating service $SERVICE_NAME file"

  echo $pass | sudo -S tee /etc/systemd/system/${SERVICE_NAME//'"'/}.service > /dev/null << EOM
[Unit]
Description=Localtunnel Daemon
After=syslog.target network.target

[Service]
# Change the user variable here according to your needs
User=root

Type=simple

ExecStart=/usr/local/bin/lt --subdomain bimlgvisualizer-socket --port 3220
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOM

  # restart daemon, enable and start service
  echo "Reloading daemon and enabling service" | tee -a ./logs/$filename
  echo $pass | sudo -S systemctl daemon-reload 
  echo $pass | sudo -S systemctl enable ${SERVICE_NAME//'.service'/} # remove the extension
  echo $pass | sudo -S systemctl start ${SERVICE_NAME//'.service'/}
  echo "Service $SERVICE_NAME Started" | tee -a ./logs/$filename
fi

# Install npm dependencies
time=$(date +%H:%M:%S)
echo "[$time] Installing server dependencies..." | tee -a ./logs/$filename
npm install 2>> ./logs/$filename

# Add access for pm2
echo $pass | sudo -S chown lg:lg /home/lg/.pm2/rpc.sock /home/lg/.pm2/pub.sock

# Stop server if already started
pm2 delete BIMLGVIS_PORT:3210 2> /dev/null

# Start server
time=$(date +%H:%M:%S)
echo "[$time] Starting pm2..." | tee -a ./logs/$filename
pm2 start npm --name BIMLGVIS_PORT:3210 -- start 2>> ./logs/$filename
pm2 save 2>> ./logs/$filename

# Add automatic pm2 resurrect script
time=$(date +%H:%M:%S)
echo "[$time] Updating resurrect script..." | tee -a ./logs/$filename
RESURRECT=$(pm2 startup | grep 'sudo')
eval $RESURRECT 2>> ./logs/$filename

time=$(date +%H:%M:%S)
echo "[$time] Installation complete. Reboot machine to finish installation" | tee -a ./logs/$filename