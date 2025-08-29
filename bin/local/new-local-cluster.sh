#!/bin/bash

set -e

### failsafe logic to exit in case we are not running in our local minikube context
KUBE_CONTEXT=$(kubectl config current-context)

echo "Current kube context: '${KUBE_CONTEXT}'"

if [[ "${KUBE_CONTEXT}" != "minikube-wbaas" ]]; then
    echo "Error: wrong kube context. Use this script only within 'minikube-wbaas'!"
    exit 1
fi
#####################################################################################

# This script should re-create your local minikube cluster without requiring any additional input (can take about ~20 minutes)

WBAAS_DEPLOY_DIR=$(realpath $(dirname $0)/../../)

echo "⚠️ DELETING your local cluster in 10 seconds ... all data will be lost! (press ctrl+c NOW to cancel) ⚠️"
sleep 10

cd "$WBAAS_DEPLOY_DIR"
make minikube-delete
make minikube-start

cd "$WBAAS_DEPLOY_DIR/tf/env/local/"
tofu apply -auto-approve # bad practice - you won't have a second chance to check for destructive actions

cd "$WBAAS_DEPLOY_DIR/k8s/helmfile/"
helmfile --environment local deps

set +e # disable exit on error for this one, see next step
helmfile --environment local apply
set -e

# workaround in anticipation of apply not finishing up for some reason (happens sometimes on some machines)
sleep 60
helmfile --environment local sync

# run initial database migrations in case the pre-install-job failed for some reason
# https://github.com/wbstack/charts/blob/main/charts/api/templates/pre-install-job.yaml#L39
#kubectl exec -ti deployments/api-app-backend -- bash -c 'php artisan migrate:install; php artisan migrate --force; php artisan passport:client --personal --no-interaction; php artisan passport:client --password --no-interaction'

if [[ -d "${FIREFOX_PROFILE}" ]]; then
  "$WBAAS_DEPLOY_DIR/bin/local/install-ca-cert-firefox.sh"
fi

echo
echo "Finished re-initializing local cluster."
echo "To also create a local user account, open the minikube tunnel and run './bin/local/create-local-user.sh'."
