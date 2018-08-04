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

echo "running yum update" 2>&1 | tee -a $LOGFILE
# sudo yum remove docker \
#     docker-client \
#     docker-client-latest \
#     docker-common \
#     docker-latest \
#     docker-latest-logrotate \
#     docker-logrotate \
#     docker-selinux \
#     docker-engine-selinux \
#     docker-engine 2>&1 | tee -a $LOGFILE

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2 2>&1 | tee -a $LOGFILE

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo  2>&1 | tee -a $LOGFILE

sudo yum install -y docker-ce 2>&1 | tee -a $LOGFILE

sudo usermod -aG docker opc  | tee -a $LOGFILE

# Update firewall
sudo firewall-cmd --set-default-zone=trusted | tee -a $LOGFILE

# Add ens3 to trusted zone
sudo firewall-cmd --zone=trusted --add-interface=ens3 --permanent | tee -a $LOGFILE

#sudo firewall-cmd --add-port=2376/tcp --add-port=2377/tcp --add-port=7946/tcp --add-port=7946/udp --add-port=4789/udp --permanent  2>&1 | tee -a $LOGFILE

sudo firewall-cmd --reload 2>&1 | tee -a $LOGFILE

# Restart to let docker add it's iptable rules
sudo systemctl start docker 2>&1 | tee -a $LOGFILE

echo true > /opt/zimbra/.firstboot.status

if [ "$(cat $STATUSFILE)" = "true" ] ; then
  exit 0
else
  exit 1
fi
