#!/bin/sh

# WBS_DOMAIN should be set to the domain to reindex

kubectl create -f backUpSingleWiki.yaml -o=json --dry-run=client |\
kubectl create -f -
