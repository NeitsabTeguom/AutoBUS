#!/bin/bash
echo Stop of AutoBUS appname service

systemctl stop AutoBUS.appname # stop service to release any file locks which could conflict with dotnet publish
