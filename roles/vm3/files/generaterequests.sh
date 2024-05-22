#!/bin/bash

METHODS=("GET" "POST" "PUT" "DELETE")

RESOURCES=("/resource" "/200" "/400" "/300" "/500")

while true; do
    METHOD=${METHODS[$RANDOM % ${#METHODS[@]}]}
    RESOURCE=${RESOURCES[$RANDOM % ${#RESOURCES[@]}]}

    DATA=""
    if [ "$METHOD" == "POST" ] || [ "$METHOD" == "PUT" ]; then
        PARAM1="param1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)"
        PARAM2="param2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 6 | head -n 1)"
        DATA="$PARAM1&$PARAM2"
    fi

    curl -X $METHOD -d "$DATA" "http://localhost$RESOURCE"

    sleep 0.1
done