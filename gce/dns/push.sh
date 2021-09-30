#!/usr/bin/env bash

# Updates the DNS zone based on the ./*-zone files in this repo
gcloud dns record-sets import ./zone-wikibase-cloud --zone=wikibase-cloud-zone --delete-all-existing
gcloud dns record-sets import ./zone-wikibase-dev --zone=wikibase-dev --delete-all-existing

