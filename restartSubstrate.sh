#!/bin/bash
timestamp()
{
 date +"%Y-%m-%d %T"
}


a=$(/bin/netstat -tulpn | awk '{print $7}' |  grep substrate | wc -l )
if test $a = "0"
then
 echo "$(timestamp): Polkadot Validator Down" >> /var/log/polkamonitor.log
 /substrate/target/release/substrate --name $POLKADOT_NAME_POC3 --validator --key $POLKADOT_KEY_POC3 &>> /var/log/polkamonitor.log
fi

# Every Minute a check, add the following cron-job
# * * * * *   /root/polkamonitor.sh  > /dev/null 2>&1
# crontab -e
# grep cron /var/log/syslog

# https://tutorialinux.com/securing-ssh-with-sshguard/
# https://andschwa.com/post/configuring-sshguard-on-ubuntu-server/
#  service sshguard restart
# iptables -nvL sshguard


# sudo apt-get install sshguard
# iptables -N sshguard
# ip6tables -N sshguard
# iptables -A INPUT -j sshguard
# ip6tables -A INPUT -j sshguard
# service sshguard restart