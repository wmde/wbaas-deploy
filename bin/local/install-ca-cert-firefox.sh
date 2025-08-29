#!/bin/bash
#
# Installs (and replaces) the current local minikube CA certificate into your firefox profile
# FIREFOX_PROFILE needs to be set, for example via direnv or ~/.profile
#
# With 'ls -lt ~/.mozilla/firefox/' it should be possible to find out which is your currently used profile 
# when comparing the modification dates of the directories (latest one = that's probably it)
#
# If this script fails with something like 'dial tcp [::1]:8080: connect: connection refused"'
# make sure that your minikube cluster is running and initialized
#

### failsafe logic to exit in case we are not running in our local minikube context
KUBE_CONTEXT=$(kubectl config current-context)

echo "Current kube context: '${KUBE_CONTEXT}'"

if [[ "${KUBE_CONTEXT}" != "minikube-wbaas" ]]; then
    echo "Error: wrong kube context. Use this script only within 'minikube-wbaas'!"
    exit 1
fi

if [[ -z "${FIREFOX_PROFILE}" || ! -d "${FIREFOX_PROFILE}" ]]; then
  echo "Please set '\$FIREFOX_PROFILE', should look something like ~/.mozilla/firefox/1234.default"
  echo "Current value: '${FIREFOX_PROFILE}'"
  exit 2
fi

set -euo pipefail

FIREFOX_PROFILE=$(realpath "${FIREFOX_PROFILE}")
CERT_NAME='wikibase-local-root-ca'
CERT_PATH="/tmp/wikibase-local-ca.crt"

kubectl get secret wikibase-local-tls -o json | jq -r '.data."ca.crt"' | base64 -d > "${CERT_PATH}"

certutil -d sql:"${FIREFOX_PROFILE}" -A -n "${CERT_NAME}" -t 'C,,' -i "${CERT_PATH}"
certutil -d sql:"${FIREFOX_PROFILE}" -L -n "${CERT_NAME}"

echo "Certificate successfully installed."
