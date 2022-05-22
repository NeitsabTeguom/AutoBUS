#!/bin/bash

# https://valadoc.org/

## PARAMS
appName=${appName:-''}
valacOptions=${valacOptions:-''}
pkg=${pkg:-''}
output=${output:-Release}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi

  shift
done

#if [ -n "$pkg" ]
#then
#      pkg="--pkg ${pkg}"
#fi

## SEARCH FILES

valaFiles=`find . -type f ! -path './bin/*' -name '*.vala'  | tr '\n' ' '`
valaCommonFiles=`find ../Common -type f -name '*.vala'  | tr '\n' ' '`

## COMPILE

rm -rf ./bin/$output/

echo valac $valacOptions $pkg $valaFiles $valaCommonFiles -d ./bin/$output/ -o $appName
valac $valacOptions $pkg $valaFiles $valaCommonFiles -d ./bin/$output/ -o $appName

chmod +x ./bin/$output/$appName
