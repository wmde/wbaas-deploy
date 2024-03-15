#!/bin/sh

# WBS_DOMAIN should be set to the domain to reindex
# CLUSTER_NAME can be set when a single cluster should be targeted. Defaults to `all`
# MW_WRITE_ONLY_ELASTICSEARCH_HOST can be set to override the currently used host value (might be empty)

tmp_file=$(mktemp --suffix=.json)

MW_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=mediawiki,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")
MW_POD_JSON=$(kubectl get pods $MW_POD -o=json)
echo ${MW_POD_JSON} > $tmp_file

kubectl create -f elasticSearchInitJob.yaml -o=json --dry-run=client |\
jq -s ".[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image" - $tmp_file |\
jq ".[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env" |\
jq ".[0]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_DOMAIN\", \"value\": \"${WBS_DOMAIN}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"CLUSTER_NAME\", \"value\": \"${CLUSTER_NAME:-all}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"MW_WRITE_ONLY_ELASTICSEARCH_HOST\", \"value\": \"${MW_WRITE_ONLY_ELASTICSEARCH_HOST}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"MW_WRITE_ONLY_ELASTICSEARCH_PORT\", \"value\": \"${MW_WRITE_ONLY_ELASTICSEARCH_PORT:-9200}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"MW_WRITE_ONLY_ELASTICSEARCH_ES6\", \"value\": \"${MW_WRITE_ONLY_ELASTICSEARCH_ES6:-false}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"MW_ELASTICSEARCH_SHARED_INDEX_NAME\", \"value\": \"${MW_ELASTICSEARCH_SHARED_INDEX_NAME:-null}\"}]" |\
kubectl create -f -
