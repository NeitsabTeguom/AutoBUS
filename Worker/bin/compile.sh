#!/bin/bash

## PARAMS

valacOptions=${valacOptions:-}
output=${output:-Release}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
   fi

  shift
done

## SEARCH FILES

valaFiles=`find . -type f ! -path './bin/*' -name '*.vala'  | tr '\n' ' '`

## COMPILE

rm -rf ./bin/$output/

valac $valacOptions $valaFiles -d ./bin/$output/ -o AutoBUS

chmod +x ./bin/$output/AutoBUS