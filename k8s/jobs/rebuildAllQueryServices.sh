tmp_file=$(mktemp --suffix=.json)

API_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=api,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")
API_POD_JSON=$(kubectl get pods $API_POD -o=json)
echo ${API_POD_JSON} > $tmp_file

kubectl create -f rebuildAllQueryServices.yaml -o=json --dry-run=client |\
jq -s ".[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image" - $tmp_file |\
jq ".[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env" |\
jq ".[0]" |\
kubectl create -f -
