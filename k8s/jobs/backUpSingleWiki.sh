#!/bin/sh

# WBS_DOMAIN should be set to the domain to reindex

kubectl apply -f backUpSingleWikiPvc.yaml

kubectl create -f backUpSingleWiki.yaml -o=json --dry-run=client |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"DATABASE_NAME\", \"value\": \"${DATABASE_NAME}\"}]" |\
kubectl create -f -
