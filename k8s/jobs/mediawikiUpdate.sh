#!/bin/bash
set -euo pipefail

# Run MediaWiki "update.php" script in a k8s job. This can be used to update a specific wiki
# Usage: "./mediawikiUpdate.sh <wbs_domain> <mediawiki_instance> <platform_api_version>"
# Example: ./mediawikiUpdate.sh test1.wbaas.dev mediawiki-143 wm1.43-wbs1
# Note: The Job runs update.php with flags: --skip-config-validation, --skip-external-dependencies, --quick, --force.
# The script now streams the job logs automatically (use the kubectl command below for re-tailing if needed).
# Tail logs manually with: "kubectl logs -n adhoc-jobs -l job-name=$(kubectl get jobs -n adhoc-jobs -o jsonpath=\"{.items[-1:].metadata.name}\") --timestamps -f"

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <wbs_domain> <mediawiki_instance> <platform_api_version>" >&2
  exit 1
fi

WBS_DOMAIN=$1
MEDIAWIKI_INSTANCE=$2
PLATFORM_VERSION_VALUE=$3

# Step 1: Find a running MediaWiki backend pod (update instance as needed)
MW_POD=$(kubectl get pods \
  --field-selector='status.phase=Running' \
  -l app.kubernetes.io/name=mediawiki \
  -l app.kubernetes.io/component=app-backend \
  -l app.kubernetes.io/instance=${MEDIAWIKI_INSTANCE} \
  -o jsonpath="{.items[0].metadata.name}" 2>/dev/null)

if [[ -z "${MW_POD}" ]]; then
  echo "No running MediaWiki backend pod found for instance ${MEDIAWIKI_INSTANCE}." >&2
  exit 1
fi

# Step 2: Get its full JSON
kubectl get pod "$MW_POD" -o=json > mw_pod.json

# Step 3: Build a Job from the template
kubectl create -f mediawikiUpdate.yaml -o=json --dry-run=client | \
  jq -s '.[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image' - mw_pod.json | \
  jq '.[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env' | \
  jq --arg wbs "$WBS_DOMAIN" --arg mwver "$PLATFORM_VERSION_VALUE" '.[0].spec.template.spec.containers[0].env += [{"name": "WBS_DOMAIN", "value": $wbs}, {"name": "MW_VERSION", "value": $mwver}]' | \
  # jq ".[0].spec.template.spec.containers[0].env += [{\"name\": \"PLATFORM_API_BACKEND_HOST\", \"value\": https://bc72affc51364420b33a1dbea0df748c.api.mockbin.io/\""}]" | \
  jq '.[0]' | \
  kubectl create -f -
