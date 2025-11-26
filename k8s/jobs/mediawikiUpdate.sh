#!/bin/bash
# Error if something terminates with a non-zero exit code (even in a pipe) of if referncing an unbound variable
# this means we don't need to check all variables are defined
set -euo pipefail

# Example of ENV variables to set
# WBS_DOMAIN=coffeebase.wikibase.cloud
# MEDIAWIKI_BACKEND_INSTANCE_LABEL=mediawiki-143
# MW_VERSION=mw1.43-wbs1

# find a running a suitable MediaWiki backend pod to reuse the image and environment variables from
MW_POD=$(kubectl get pods \
  --field-selector='status.phase=Running' \
  -l app.kubernetes.io/name=mediawiki \
  -l app.kubernetes.io/component=app-backend \
  -l app.kubernetes.io/instance="${MEDIAWIKI_BACKEND_POD_INSTANCE}" \
  -o jsonpath="{.items[0].metadata.name}" 2>/dev/null)

if [[ -z "${MW_POD}" ]]; then
  echo "No running MediaWiki backend pod found with name ${MEDIAWIKI_BACKEND_POD_INSTANCE}." >&2
  exit 1
fi

# store the yaml pod in temporary file
tmp_file=$(mktemp --suffix=.json)
kubectl get pod "$MW_POD" -o=json > "$tmp_file"

#build Job from the template
# create an initial Job json from the Job yaml (e.g. doing things like generating the name from the template)
kubectl create -f mediawikiUpdate.yaml -o=json --dry-run=client | \
  # ingest that Job yaml from stdin and the pod temp file using jq slurp mode
  # then set the image in the new Job spec to use the image from the existing Pod spec
  jq -s '.[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image' - "$tmp_file" | \
  # set the env vars of the container in the Job to match the existing Pod
  jq '.[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env' | \
  # set two specific ENV vars in the job from ENV vars in this script
  jq --arg wbs "$WBS_DOMAIN" --arg mwver "$MW_VERSION" '.[0].spec.template.spec.containers[0].env += [{"name": "WBS_DOMAIN", "value": $wbs}, {"name": "MW_VERSION", "value": $mwver}]' | \
  # return just the Job spec (dropping the existing Pod one)
  jq '.[0]' | \
  # create the now fully formed Job from the spec
  kubectl create -f -
