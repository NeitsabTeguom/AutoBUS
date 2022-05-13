@echo off
TITLE Uninstall of AutoBUS appname service

sc stop AutoBUSappname

:loop
sc query AutoBUSappname | find "STOPPED"
if errorlevel 1 (
  timeout 1
  goto loop
)

sc delete AutoBUSappname

timeout 5

rmdir .\bin\ /s /q
del *.cmd
