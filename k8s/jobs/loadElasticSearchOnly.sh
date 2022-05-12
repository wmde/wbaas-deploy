WIKI_ID=$(kubectl exec -it deployments/api-app-backend -- sh -c "php artisan wbs-wiki:get domain $WBS_DOMAIN" | jq -r '.id' )
API_POD=$(kubectl get pods --field-selector='status.phase=Running' -l app.kubernetes.io/name=api,app.kubernetes.io/component=app-backend -o jsonpath="{.items[0].metadata.name}")
API_POD_JSON=$(kubectl get pods $API_POD -o=json)
echo ${API_POD_JSON} > api_pod.json

kubectl create -f elasticSearchImportJob.yaml -o=json --dry-run=client |\
jq -s ".[0].spec.template.spec.containers[0].image = .[1].spec.containers[0].image" - api_pod.json |\
jq ".[0].spec.template.spec.containers[0].env = .[1].spec.containers[0].env" |\
jq ".[0]" |\
jq ".spec.template.spec.containers[0].env += [{\"name\": \"WIKI_ID\", \"value\": \"${WIKI_ID}\"}]" |\
kubectl create -f -