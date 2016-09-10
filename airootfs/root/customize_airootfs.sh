#!/bin/bash

exam_user="moe-exam"
exam_ip="192.168.56.1"

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# use Jakarta's time as reference
ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

usermod -s /usr/bin/zsh root

if [ ! -z "$exam_user" ]; then
  # enable autologin
  groupadd -r autologin || true
  useradd -mG autologin -s /bin/zsh ${exam_user} || true
  passwd -d ${exam_user} # remove password

  cp -aT /etc/skel/ /home/"$exam_user"
  chown -R "$exam_user:$exam_user" /home/"$exam_user"

  # replace the EXAM_USER string in lightdm.conf with the correct one
  sed -i "s/EXAM_USER/${exam_user}/" /etc/lightdm/lightdm.conf
fi

cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default graphical.target

# network settings
iptables -F # delete everything
iptables -P FORWARD DROP # we aren't a router
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s ${exam_ip} -j ACCEPT
iptables -P INPUT DROP # Drop everything we don't accept

# lock the root user
passwd -l root
