#!/bin/bash

# Based on flood-run-e2e.sh in https://github.com/wilsonmar/DevSecOps/tree/master/flood-io
# from https://docs.flood.io/#end-to-end-example retrieved 8 July 2019.
# to launch and run flood tests.
# Written by WilsonMar@gmail.com

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/wilsonmar/DevSecOps/master/flood-io/flood-run-e2e.sh)"

# This is free software; see the source for copying conditions. There is NO
# warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

set -e  # exit script if any command returnes a non-zero exit code.
# set -x  # display every command.

## Reset data from previous run:
unset $pFLOOD_API_TOKEN
unset $pFLOOD_UUID

$pFLOOD_API_TOKEN = $FLOOD_API_TOKEN
echo -e "\n>>> FLOOD_API_TOKEN is: $pFLOOD_API_TOKEN"
$pFLOOD_UUID = $FLOOD_UUID
echo -e "\n>>> FLOOD_UUID is: $pFLOOD_UUID"

# PROTIP: use environment variables to pass links to where the secret is really stored: use an additional layer of indirection.
# From https://app.flood.io/account/user/security
#FLOOD_USER=$(flood_api_token)+":x"
#if [ -z "$FLOOD_API_TOKEN" ]; then
#   echo -e "\n>>> FLOOD_API_TOKEN not available. Exiting..."
#   exit 9
#else
#   echo -e "\n>>> FLOOD_API_TOKEN available. Continuing..."
#fi
## To sign into https://app.flood.io/account/user/security (API Access)
#if [ -z "$FLOOD_USER" ]; then
#   echo -e "\n>>> FLOOD_USER not available. Exiting..."
#   exit 9
#else
#   echo -e "\n>>> FLOOD_USER available. Continuing..."
#fi

   #Login=$(curl -X POST https://api.flood.io/oauth/token -F 'grant_type=password' \
   #   -F 'username=$FLOOD_USERNAME' -F 'password=$FLOOD_PASSWORD') #required username and password
   ## echo $Login
   #Token=$(echo $Login | jq -r '.access_token')
   #Patch=$(curl -X PATCH https://api.flood.io/api/v3/floods/$flood_uuid/set-public -H 'Authorization: Bearer '$Token -H 'Content-Type: application/json')

   #echo -e "\n>>> [$(date +%FT%T)+00:00] See dashboard at https://api.flood.io/$flood_uuid while waiting:"
   #echo "    (One dot every $FLOOD_SLEEP_SECS seconds):"
   #while [ $(curl --silent --user $FLOOD_API_TOKEN: -X GET https://api.flood.io/floods/$flood_uuid | jq -r '.status == "finished"') = "false" ]; do
   #  echo -n "."
   #  sleep "$FLOOD_SLEEP_SECS"
   #done

   #echo "   ERROR: Authentication required to view this Flood ???"
   #echo -e "\n>>> [$(date +%FT%T)+00:00] Get the summary report"
   #flood_report=$(curl --silent --user $FLOOD_API_TOKEN:  -X GET https://api.flood.io/floods/$flood_uuid/report \
   #    | jq -r ".summary" )
   #echo -e "\n>>> [$(date +%FT%T)+00:00] Detailed results at https://api.flood.io/floods/$flood_uuid"
   #echo "$flood_report"  # summary report

   #Optionally store the CSV results
   #echo -e "\n>>> [$(date +%FT%T)+00:00] Storing CSV results in results.csv"
   #curl --silent --user $FLOOD_API_TOKEN: https://api.flood.io/csv/$flood_uuid/$flood_uuid \
   #   > result.csv

   #if [ ! -f result.csv ]; then
   #   echo -e "\n>>> result.csv not available. Exiting..."
   #   exit 9
   #else
   #   echo -e "\n>>> result.csv ..."
   #   head 1 result.csv
   #      # {"error":"Sorry, we cannot find that resource. If you'd like assistance please contact support@flood.io"}
   #fi

#done



