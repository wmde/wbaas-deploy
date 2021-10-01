#!/usr/bin/env bash

## Create a IAM service account called certman-dns01-solve and give it `dns.admin` role
#  Then run these commands separately

## get a new key to the service account
# gcloud iam service-accounts keys create ./certman-dns01-solver-1.json --iam-account certman-dns01-solver@wikibase-cloud.iam.gserviceaccount.com 

## make the key on disk a k8s secret
# kubectl create secret generic clouddns-dns01-solver-svc-acct --namespace=cert-manager --from-file=key.json=./certman-dns01-solver-1.json --dry-run=client --output=yaml > ./clouddns-dns01-solver-svc-acct.yaml

## add the secret to the cluster
# kubectl apply -f ./clouddns-dns01-solver-svc-acct.yaml