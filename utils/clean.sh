#/bin/bash

cd ../

echo Cleaning : Router
rm -rf ./Router/bin/Debug/*
rm -rf ./Router/bin/Release/*

echo Cleaning : Worker
rm -rf ./Worker/bin/Debug/*
rm -rf ./Worker/bin/Release/*

echo Cleaning : Manager
rm -rf ./Manager/bin/Debug/*
rm -rf ./Manager/bin/Release/*

