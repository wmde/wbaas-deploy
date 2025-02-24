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

# This script should create and verify a user account on a local wbaas cluster with the credentials below. Do not use this in production! 

USER_CODE="${USER_CODE:-create-local-user}"
USER_MAIL="${USER_MAIL:-jane.doe@wikimedia.de}"
USER_PASS="${USER_PASS:-wikiwikiwiki}"

echo
echo "> Creating local user '${USER_MAIL}' ..."
kubectl --context ${KUBE_CONTEXT} exec deployments/api-app-backend -- \
    php artisan tinker --execute \
        "(new UserCreateJob('${USER_MAIL}', '${USER_PASS}'))->handle(); \$user = User::firstWhere('email', '${USER_MAIL}'); \$user->markEmailAsVerified(); \$user->save(); echo PHP_EOL . \$user;"

echo
echo "To also create a local wiki run './bin/local/create-local-wiki.sh'"

