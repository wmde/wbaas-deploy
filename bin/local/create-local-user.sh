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

[[ $(type -P "jq") ]] || { echo "error: 'jq' is not installed." 1>&2; exit 1; }
[[ $(type -P "jo") ]] || { echo "error: 'jo' is not installed." 1>&2; exit 1; }

# This script should create and verify a user account on a local wbaas cluster with the credentials below. Do not use this in production! 

USER_CODE="${USER_CODE:-create-local-user}"
USER_MAIL="${USER_MAIL:-jane.doe@wikimedia.de}"
USER_PASS="${USER_PASS:-wikiwikiwiki}"

TEST_RESPONSE=$(curl -s http://api.wbaas.localhost/healthz)
if [[ "${TEST_RESPONSE}" != "It's Alive" ]]; then
    echo "Error: local api is not available. Is the minikube tunnel open? ('make minikube-tunnel')"
    exit 2
fi

echo "> Creating local invite code '${USER_CODE}' ..."
kubectl --context ${KUBE_CONTEXT} exec deployments/api-queue -- php artisan wbs-invitation:create ${USER_CODE}

echo "> Registering local user '${USER_MAIL}' ..."

CREATE_USER_DATA=$(jo email="${USER_MAIL}" password="${USER_PASS}" invite="${USER_CODE}" recaptcha="localdebug")
curl -s 'http://api.wbaas.localhost/user/register' \
    -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    --data-raw "${CREATE_USER_DATA}"

echo
echo "> Verifying local user '${USER_MAIL}' ..."
kubectl --context ${KUBE_CONTEXT} exec deployments/api-app-backend -- \
    php artisan tinker --execute \
        "User::firstWhere(['email' => '${USER_MAIL}'])->update(['verified' => 1])"
