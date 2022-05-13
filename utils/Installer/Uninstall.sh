#!/bin/bash
echo Uninstall of AutoBUS appname service

systemctl stop AutoBUS.appname.service
systemctl disable AutoBUS.appname.service
systemctl revert AutoBUS.appname.service
systemctl reset-failed
rm -f /etc/systemd/system/AutoBUS.appname.service
systemctl daemon-reload

rm -rf /usr/sbin/AutoBUS/appname/*

