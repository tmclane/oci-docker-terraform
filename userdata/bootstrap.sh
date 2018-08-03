#!/bin/bash
set -euxo pipefail

LOGFILE="/opt/zimbra/log/first-boot.log"
STATUSFILE="/opt/zimbra/.firstboot.status"

if [ -f "$STATUSFILE" ] ; then
  exit 0
fi

mkdir -p $(dirname $LOGFILE)
touch $LOGFILE
chmod 600 $LOGFILE

${custom_userdata} 2>&1 | tee -a $LOGFILE

#apt update
#apt upgrade -y

# iptables -P INPUT ACCEPT
# iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT
# iptables -t nat -F
# iptables -t mangle -F
iptables -F
iptables -X

# ip6tables -P INPUT ACCEPT
# ip6tables -P FORWARD DROP
# ip6tables -P OUTPUT ACCEPT
# ip6tables -t nat -F
# ip6tables -t mangle -F
# ip6tables -F
# ip6tables -X

# Maybe not needed?
#echo '{"hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]}'> /etc/docker/daemon.json
#echo "Updating /lib/systemd/system/docker.service" | tee -a $LOGFILE
#sed -i -e 's/ExecStart=.*/ExecStart=\/usr\/bin\/dockerd/g'  /lib/systemd/system/docker.service

#systemctl daemon-reload 2>&1 | tee -a $LOGFILE

# Restart to let docker add it's iptable rules
#systemctl restart docker 2>&1 | tee -a $LOGFILE

echo true > /opt/zimbra/.firstboot.status

if [ "$(cat $STATUSFILE)" = "true" ] ; then
  exit 0
else
  exit 1
fi
