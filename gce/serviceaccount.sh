#!/usr/bin/env bash

# This file origionally containers the code to create and get keys from service accounts.
# Service account creation is now done in Terraform
# Key getting is still done in here right now

## Listing existing service accounts
# gcloud iam service-accounts list

## Delete some account by email
# gcloud iam service-accounts delete service-account-wbstack-api@wikibase-cloud.iam.gserviceaccount.com

## Create a IAM service account called certman-dns01-solver and afterwards give it `dns.admin` role manually in gui
bash ./serviceaccount/create.sh certman-dns01-solver cert-manager

## Create API service account for api (stackdriver, logos)
bash ./serviceaccount/create.sh wikibase-dev-api default