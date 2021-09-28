#!/usr/bin/env bash

# Updates the DNS zone based on the ./*-zone files in this repo
gcloud dns record-sets export ./zone-wikibase-cloud --zone=wikibase-cloud-zone
