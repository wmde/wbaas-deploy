
# WBS_FORCE_SEARCH_INDEX_FROM should be set to time to reindex from (exclusive) in YYYY-mm-ddTHH:mm:ssZ format
# WBS_DOMAIN should be set to the domain to reindex

tmp_file=$(mktemp --suffix=.json)

MW_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=mediawiki,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")
MW_POD_JSON=$(kubectl get pods $MW_POD -o=json)
echo ${MW_POD_JSON} > $tmp_file

kubectl create -f forceSearchIndexFrom.yaml -o=json --dry-run=client |\
jq -s ".[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image" - $tmp_file |\
jq ".[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env" |\
jq ".[0]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_DOMAIN\", \"value\": \"${WBS_DOMAIN}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_FORCE_SEARCH_INDEX_FROM\", \"value\": \"${WBS_FORCE_SEARCH_INDEX_FROM}\"}]" |\
kubectl create -f -
