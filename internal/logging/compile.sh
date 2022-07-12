#!/bin/bash

cd "$(dirname "$0")"

if [[ ! -f liblogging.so ]]
then
	## PARAMS
	appDirectory=${appName:-''}

	while [ $# -gt 0 ]; do

	   if [[ $1 == *"--"* ]]; then
		param="${1/--/}"
		declare $param="$2"
		# echo $1 $2 // Optional to see the parameter:value result
	   fi

	  shift
	done

	valac --pkg gmodule-2.0 -o liblogging.so --library logging -X -fPIC -X -shared logging.vala ../../Common/Plugins/Interfaces/ILogging.vala
fi

if [[ ! -f ../../$appDirectory/internal/liblogging.so ]]
then
	mkdir -p ../../$appDirectory/internal/
	cp -f liblogging.so ../../$appDirectory/internal/
fi
