#!/bin/bash

mypath=`dirname $(realpath $0)`

unameOut=$(uname -a)
case "${unameOut}" in
	*Microsoft*)	OSType="WSL";; #must be first since Windows subsystem for linux will have Linux in the name too
	*microsoft*)	OSType="WSL2";;
	Linux*)	OSType="LINUX";;
	FreeBSD*)	OSType="UNIX";;
	Darwin*)	OSType="OSX";;
	CYGWIN*)	OSType="WINDOWS";;
	MINGW*)	OSType="WINDOWS";;
	*Msys)	OSType="WINDOWS";;
	*)	OSType="UNKNOWN:${unameOut}"
esac

# POSIX (other)

echo OS ----------------------------------------------
echo "$OSType"
echo -------------------------------------------------

# https://valadoc.org/

## PARAMS
appName=${appName:-''}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi

  shift
done

## RELEASE / DEBUG

if [ -n "$debug" ]; then
	valacOptions="--debug -D DEBUG $valacOptions"
	output="Debug"
else
	output="Release"
fi

## APPNAME

if [[ $OSType == "WINDOWS" ]]; then
	 appName="$appName.exe"
fi

## CLEANING

rm -f ./bin/$output/*

## PACKAGES

if [ -f ./pkg ]; then
	pkg=`cat pkg`
fi

## SEARCH FILES

valaFiles=`find . -type f ! -path './bin/*' -name '*.vala'  | tr '\n' ' '`
valaCommonFiles=`find ../Common -type f -name '*.vala'  | tr '\n' ' '`


## PLUGINS

mkdir -p ./bin/$output/internal/
if [[ ! -f ./bin/$output/internal/liblogging.so ]]
then
	valac --pkg gmodule-2.0 -d ./bin/$output/internal/ -o liblogging.so --library logging -X -fPIC -X -shared ../internal/logging/logging.vala ../Common/Plugins/Interfaces/ILogging.vala
	rm -rf ./bin/$output/internal/*.vapi
fi

## COMPILE

echo valac $valacOptions -D $OSType $pkg $valaFiles $valaCommonFiles -d ./bin/$output/ -o $appName
valac $valacOptions -D $OSType $pkg $valaFiles $valaCommonFiles -d ./bin/$output/ -o $appName

chmod +x ./bin/$output/$appName

## COPY DEPENDENCIES

if [ -z ${debug+xxx} ]; then
	if [ "$OSType"="WINDOWS" ]; then
		ldd ./bin/$output/$appName | grep mingw | sort -u | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./bin/$output/
	fi
fi
