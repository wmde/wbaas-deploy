#!/bin/bash
set -o pipefail

# Run MediaWiki "update.php" script in a k8s job. This can be used to update a specific wiki
# Usage: "./mediawikiUpdate.sh <wbs_domain>"
# Example: ./mediawikiUpdate.sh mywayordatway.wikibase.dev

if [[ $# -lt 3 ]]; then
  echo "Update: $0 <wbs_domain>" >&2
  exit 1
fi

WBS_DOMAIN=$1
MEDIAWIKI_BACKEND_POD=mediawiki-143
MW_VERSION=mw1.43-wbs

# Step 1: Find a running MediaWiki backend pod (update instance as needed)
MW_POD=$(kubectl get pods \
  --field-selector='status.phase=Running' \
  -l app.kubernetes.io/name=mediawiki \
  -l app.kubernetes.io/component=app-backend \
  -l app.kubernetes.io/instance=${MEDIAWIKI_BACKEND_POD} \
  -o jsonpath="{.items[0].metadata.name}" 2>/dev/null)

if [[ -z "${MW_POD}" ]]; then
  echo "No running MediaWiki backend pod found with name ${MEDIAWIKI_BACKEND_POD}." >&2
  exit 1
fi

# Step 2: Get its full JSON
kubectl get pod "$MW_POD" -o=json > mw_pod.json

# Step 3: Build a Job from the template
kubectl create -f mediawikiUpdate.yaml -o=json --dry-run=client | \
  jq -s '.[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image' - mw_pod.json | \
  jq '.[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env' | \
  jq --arg wbs "$WBS_DOMAIN" --arg mwver "$MW_VERSION" '.[0].spec.template.spec.containers[0].env += [{"name": "WBS_DOMAIN", "value": $wbs}, {"name": "MW_VERSION", "value": $mwver}]' | \
  jq '.[0]' | \
  kubectl create -f -
