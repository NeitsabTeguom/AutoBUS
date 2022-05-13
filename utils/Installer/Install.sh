#!/bin/bash
echo Install of AutoBUS appname service

/usr/sbin/AutoBUS/appname/Uninstall.sh

mkdir /usr/sbin/AutoBUS/
mkdir /usr/sbin/AutoBUS/appname/
mkdir /usr/sbin/AutoBUS/appname/bin/

cp ./Start.sh /usr/sbin/AutoBUS/appname/
cp ./Stop.sh /usr/sbin/AutoBUS/appname/
cp ./Uninstall.sh /usr/sbin/AutoBUS/appname/
cp -r ./bin/* /usr/sbin/AutoBUS/appname/bin/
sudo chmod +x /usr/sbin/AutoBUS/appname/*.sh

sudo chmod +x /usr/sbin/AutoBUS/appname/bin/AutoBUS.appname

systemctl stop AutoBUS.appname.service
cp AutoBUS.appname.service /etc/systemd/system/AutoBUS.appname.service
systemctl daemon-reload
systemctl enable AutoBUS.appname.service
systemctl start AutoBUS.appname.service

