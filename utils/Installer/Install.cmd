@echo off
TITLE Install of AutoBUS appname service

set mypath=%~dp0

"%ProgramFiles%\AutoBUS\appname\Uninstall.cmd"

mkdir "%ProgramFiles%\AutoBUS\"
mkdir "%ProgramFiles%\AutoBUS\appname\"
xcopy %mypath%Start.cmd "%ProgramFiles%\AutoBUS\appname\" /B/V/Y/E
xcopy %mypath%Stop.cmd "%ProgramFiles%\AutoBUS\appname\" /B/V/Y/E
xcopy %mypath%Uninstall.cmd "%ProgramFiles%\AutoBUS\appname\" /B/V/Y/E
xcopy %mypath%bin\* "%ProgramFiles%\AutoBUS\appname\bin\" /B/V/Y/E

sc create AutoBUSappname start= auto binPath= "%ProgramFiles%\AutoBUS\appname\bin\AutoBUS.appname.exe" displayname= "AutoBUS appname"
sc description AutoBUSappname "AutoBUS appname service, all in one SaaS"
sc failure AutoBUSappname reset= 86400 actions= restart/1000/restart/1000/restart/1000

sc start AutoBUSappname
