#!/bin/bash

# DATABASE_NAME should be set to the database to backup

if [[ -z "$DATABASE_NAME"  ]]; then
    echo "DATABASE_NAME not set"
    exit 1
fi

# This creates the PVC (if it doesn't exist) for backups to be saved to
# It will not be automatically deleted so you may need to clean this up when you are done
kubectl apply -f singleWikiBackupPvc.yaml

kubectl create -f singleWikiBackup.yaml -o=json --dry-run=client |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"DATABASE_NAME\", \"value\": \"${DATABASE_NAME}\"}]" |\
kubectl create -f -
