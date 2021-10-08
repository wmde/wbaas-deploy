#!/usr/bin/env bash

## Listing existing service accounts
# gcloud iam service-accounts list

## Delete some account by email
# gcloud iam service-accounts delete service-account-wbstack-api@wikibase-cloud.iam.gserviceaccount.com

## Create a IAM service account called certman-dns01-solver and afterwards give it `dns.admin` role manually in gui
bash ./serviceaccount/create.sh certman-dns01-solver cert-manager

## Create API service account for api (stackdriver, logos)
bash ./serviceaccount/create.sh wikibase-dev-api default

## add a secret to the cluster
# kubectl apply -f .serviceaccount/output/secret-wikibase-dev-api.yaml

## sql
kubectl apply -f definitions/secret-creators/role.yaml
kubectl apply -f tasks/init-sql-secrets.yaml

cd sql/
helmfile --environment local apply

kubectl apply -f tasks/init-sql.yaml 

## create service account and get secretname by 
## kubectl describe service

## localhost alternative
#
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: wikibase-dev-api
EOF

cd ../api
helmfile --environment local apply

## Apply queryserivice

cd ../queryservice
helmfile --environment local apply

cd ../queryservice-gateway
helmfile --environment local apply

cd ../queryservice-ui
helmfile --environment local apply

cd ../queryservice-updater
helmfile --environment local apply

cd ../mediawiki135
helmfile --environment local apply

cd ../platform-nginx
helmfile --environment local apply



