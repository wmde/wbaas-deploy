MW_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=mediawiki,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")
MW_POD_JSON=$(kubectl get pods $MW_POD -o=json)
echo ${MW_POD_JSON} > mw_pod.json

kubectl create -f rebuildQuantityUnitsJob.yaml -o=json --dry-run=client |\
jq -s ".[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image" - mw_pod.json |\
jq ".[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env" |\
jq ".[0]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_DOMAIN\", \"value\": \"${WBS_DOMAIN}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_UNIT_FROM\", \"value\": \"${WBS_UNIT_FROM}\"}]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_UNIT_TO\", \"value\": \"${WBS_UNIT_TO}\"}]" |\
kubectl create -f -