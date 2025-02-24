#!/bin/bash

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

# This script should create a wiki for a user account on a local wbaas cluster with the credentials below. Do not use this in production! 

USER_MAIL="${USER_MAIL:-jane.doe@wikimedia.de}"
USER_PASS="${USER_PASS:-wikiwikiwiki}"
USER_WIKI_NAME="${USER_WIKI_NAME:-Local Test Wiki}"
USER_WIKI_DOMAIN="${USER_WIKI_DOMAIN:-local-test-wiki.wbaas.localhost}"
USER_WIKI_ADMIN="${USER_WIKI_ADMIN:-Admin}"

TEST_RESPONSE=$(curl -s http://api.wbaas.localhost/healthz)
if [[ "${TEST_RESPONSE}" != "It's Alive" ]]; then
    echo "Error: local api is not available. Is the minikube tunnel open? ('make minikube-tunnel')"
    exit 2
fi

LOGIN_JSON_DATA=$(jo email="${USER_MAIL}" password="${USER_PASS}")
LOGIN_RESPONSE=$(curl -s 'http://api.wbaas.localhost/auth/login' \
    -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    --data-raw "${LOGIN_JSON_DATA}")

LOGIN_TOKEN=$(echo "${LOGIN_RESPONSE}" | jq -r '.token')
[[ -n "$LOGIN_TOKEN" ]] || { echo "error: login failed." 1>&2; exit 1; }

CREATE_WIKI_JSON_DATA=$(jo domain="${USER_WIKI_DOMAIN}" sitename="${USER_WIKI_NAME}" username="${USER_WIKI_ADMIN}")
CREATE_WIKI_RESPONSE=$(curl -s 'http://api.wbaas.localhost/wiki/create' \
    -X POST \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer ${LOGIN_TOKEN}" \
    --data-raw "${CREATE_WIKI_JSON_DATA}")

echo "$CREATE_WIKI_RESPONSE"
