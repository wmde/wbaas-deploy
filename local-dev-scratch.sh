########################################################################################################################
exit
########################################################################################################################
# Things below here still needed in this sort of order for local dev k8s setup..

## add a secret to the cluster
# kubectl apply -f .serviceaccount/output/secret-wikibase-dev-api.yaml

## sql
kubectl apply -f definitions/secret-creators/role.yaml
kubectl apply -f tasks/init-sql-secrets.yaml

cd sql/
helmfile --environment local apply

kubectl apply -f tasks/init-sql.yaml 

## create service account and get secretname by 
## kubectl describe service

## localhost alternative
#
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: wikibase-dev-api
EOF

cd ../api
helmfile --environment local apply

cd ../mediawiki135
helmfile --environment local apply

cd ../platform-nginx
helmfile --environment local apply



