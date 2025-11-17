#!/bin/bash
set -euo pipefail

# Run MediaWiki "update.php" script in a k8s job. This can be used to update a specific wiki
# Usage: "WBS_DOMAIN=coffebase.wikibase.cloud ./mediawikiUpdate.sh"
# Note: The Job runs update.php with flags: --skip-config-validation, --skip-external-dependencies, --quick, --force.
# Tail logs with: "kubectl logs -n adhoc-jobs -l job-name=$(kubectl get jobs -n adhoc-jobs -o jsonpath="{.items[-1:].metadata.name}") --timestamps -f"

# Step 1: Find a running MediaWiki backend pod
MW_POD=$(kubectl get pods \
  --field-selector='status.phase=Running' \
  -l app.kubernetes.io/name=mediawiki,app.kubernetes.io/component=app-backend \
  -o jsonpath="{.items[0].metadata.name}")

if [[ -z "${MW_POD}" ]]; then
  echo "No running MediaWiki backend pod found (label selector: name=mediawiki, component=app-backend)." >&2
  exit 1
fi

# Step 2: Get its full JSON
kubectl get pod "$MW_POD" -o=json > mw_pod.json

# Step 3: Build a Job from the template
kubectl create -f mediawikiUpdate.yaml -o=json --dry-run=client | \
  jq -s '.[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image' - mw_pod.json | \
  jq '.[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env' | \
  jq ".[0].spec.template.spec.containers[0].env += [{\"name\": \"WBS_DOMAIN\", \"value\": \"${WBS_DOMAIN:-}\"}]" | \
  jq '.[0]' | \
  kubectl create -f -
