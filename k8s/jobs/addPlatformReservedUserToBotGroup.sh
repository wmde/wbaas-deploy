#!/bin/bash

# Step 1: Get name of the running MediaWiki backend pod
MW_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=mediawiki,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")

# Step 2: Get its full JSON and save to file
MW_POD_JSON=$(kubectl get pod "$MW_POD" -o=json)
echo "${MW_POD_JSON}" > mw_pod.json

# Step 3: Create and patch the Job spec dynamically
kubectl create -f addPlatformReservedUserToBotGroupJob.yaml -o=json --dry-run=client | \
jq -s '.[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image' - mw_pod.json | \
jq '.[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env' | \
jq '.[0]' | \
kubectl create -f -