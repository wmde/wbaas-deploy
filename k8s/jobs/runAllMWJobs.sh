tmp_file=$(mktemp --suffix=.json)

MW_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=mediawiki,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")
MW_POD_JSON=$(kubectl get pods $MW_POD -o=json)
echo ${MW_POD_JSON} > $tmp_file

kubectl create -f runAllMWJobsJob.yaml -o=json --dry-run=client |\
jq -s ".[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image" - $tmp_file |\
jq ".[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env" |\
jq ".[0]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WBS_DOMAIN\", \"value\": \"${WBS_DOMAIN}\"}]" |\
kubectl create -f -
