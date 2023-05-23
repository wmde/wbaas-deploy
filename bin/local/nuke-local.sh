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

echo "⚠️ ☠️  NUKING your local cluster in 10 seconds ... all data will be lost! (press ctrl+c NOW to cancel) ☠️ ⚠️"
sleep 10

cd "$WBAAS_DEPLOY_DIR"
make minikube-delete
make minikube-start

cd "$WBAAS_DEPLOY_DIR/tf/env/local/"
terraform apply -auto-approve # bad practice - you won't have a second chance to check for destructive actions

cd "$WBAAS_DEPLOY_DIR/k8s/helmfile/"
# very bad practice - infinite `y` gets spammed to helmfile so we just blindly agree to any prompts
set +e # disable exit on error for this one, see next step
yes y | helmfile -e local apply 
set -e

helmfile -e local sync # workaround in anticipation of apply not finishing up for some reason (happens sometimes on some machines)

echo
echo "Finished re-initializing local cluster."
echo "To also create a local user account, open the minikube tunnel and run './bin/local/create-local-user.sh'."
