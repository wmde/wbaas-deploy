#!/bin/bash

DOMAINS=$(cat $1)

for domain in $DOMAINS; do
  echo "Creating job for wiki: $domain"
  domain=$(echo -e "$domain" | tr -d '\r')
  WBS_DOMAIN="$domain" ./addPlatformReservedUserToBotGroup.sh
done <$1
