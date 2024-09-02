#!/bin/bash

# DATABASE_NAME should be set to the database to restore

if [[ -z "$DATABASE_NAME"  ]]; then
    echo "DATABASE_NAME not set"
    exit 1
fi

kubectl create -f restoreSingleWiki.yaml -o=json --dry-run=client |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"DATABASE_NAME\", \"value\": \"${DATABASE_NAME}\"}]" |\
kubectl create -f -
