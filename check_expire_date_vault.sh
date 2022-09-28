#!/bin/bash

Usage () {
echo "check_expire_date_vault.sh v0.0.1"
echo "****************************"
echo "This script check all keys under a <keymgmt_path> HashiCorp Vault and prints keys that have been"
echo "created more than 12 months ago"
echo ""
echo "# ./check_expire_date_vault.sh <token> <vault> <keymgmt_path>"
echo ""
echo "Example:"
echo ""
echo "# ./check_expire_date_vault.sh s.0wtcFizyrlEc https://vault.xxx.xxx.:8200 keymgmt"
exit
}

check_prerequisities () {
  which curl > /dev/null
  if [ $? -ne 0 ]
    then
      echo "Curl binary is not present. Please install it to use this script."
      exit 1
  fi
  which jq > /dev/null
  if [ $? -ne 0 ]
    then
      echo "jq binary is not present. Please install it to use this script."
      exit 1
  fi
}

check_data () {
TIMESTAMP=$(echo $TIMESTAMP | tr -d \")
#TIMESTAMP="2021-09-08T10:25:38.688436136+02:00"
MONTH="$(echo $TIMESTAMP | cut -d '-' -f 2 | sed 's/^0*//')"
YEAR="$(echo $TIMESTAMP | cut -d '-' -f 1 | cut -d 'T' -f 1 )"
DAY="$(echo $TIMESTAMP | cut -d '-' -f 3 | cut -d 'T' -f 1 | sed 's/^0*//')"

#echo $DAY
#echo $MONTH
#echo $YEAR

if [[ "$DAY" -le "$(date +%d | sed 's/^0*//' )" ]]
then
if [[ "$MONTH" -le "$(date +%m | sed 's/^0*//')" ]]
then
if [[ "$YEAR" -lt "$(date +%Y )" ]]
then
echo $KEY2 "older than 12 months ago"
else
echo "$KEY2 not older than 12 months ago"
fi
else
echo "$KEY2 not older than 12 months ago"
fi
else
echo "$KEY2 not older than 12 months ago"
fi
}

check_prerequisities

if [ $# -eq 0 ] || [ $# -lt 3 ] || [ $# -gt 3 ]
  then
    Usage
fi

export LIST_KEYS=$(curl -s --header "X-Vault-Token: $1" --request LIST $2/v1/$3/key | jq .data.keys[])

for KEY in $LIST_KEYS
do
KEY2=$(echo $KEY | tr -d \")
#echo $KEY2
TIMESTAMP=$(curl -s --header "X-Vault-Token: $1" $2/v1/$3/key/$KEY2 | jq '.data.versions[].creation_time')
#echo $KEY2 $TIMESTAMP
check_data $KEY2 $TIMESTAMP
#check_data 
done

