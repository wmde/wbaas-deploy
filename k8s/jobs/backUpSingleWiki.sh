#!/bin/sh

# DATABASE_NAME should be set to the database to backup

kubectl apply -f backUpSingleWikiPvc.yaml

kubectl create -f backUpSingleWiki.yaml -o=json --dry-run=client |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"DATABASE_NAME\", \"value\": \"${DATABASE_NAME}\"}]" |\
kubectl create -f -
