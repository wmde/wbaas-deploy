# About this directory
The purpose of the scripts in this directory is to improve and speed up the workflow with the local minikube setup. They are mostly quick and dirty hacks but serve the purpose.

## Scripts
### [`nuke-local.sh`](./nuke-local.sh)
Deletes and tries to re-initiate the local minikube cluster in an unattended fashion (no user input/prompt approval required) by applying our terraform and helmfile configuration. It can take like ~20 minutes to finish. All data inside the local cluster will be lost. Please report if your cluster is not in a useable state after running this script, so we can improve it.

### [`create-local-user.sh`](./create-local-user.sh)
Creates a local user account that can be used immediately. The minikube tunnel needs to be open for this to work (`make minikube-tunnel`).

It does this in three steps:
1. Creates an invite code
    - by running `artisan wbs-invitation:create <code>`
2. Registers a user account
    - by using `curl` to `POST` form data to the API endpoint `/user/register`
3. Manually sets the account to verified
    - by flipping the `verified` field of the user in the database to 1
        - via a PHP snippet executed with artisan tinker (dirty)

#### Default credentials
```bash
USER_CODE="create-local-user"
USER_MAIL="jane.doe@wikimedia.de"
USER_PASS="wikiwikiwiki"
```

## Adding new scripts
### Fail safe
All of these scripts should start with this failsafe snippet, to make sure they aren't doing anything at all when executed outside of the local minikube cluster context. If `kubectl` will be used in the script, it can be forced to use the local context with each call like this: `kubectl --context ${KUBE_CONTEXT}`.

```bash
#!/bin/bash

### failsafe logic to exit in case we are not running in our local minikube context
KUBE_CONTEXT=$(kubectl config current-context)

echo "Current kube context: '${KUBE_CONTEXT}'"

if [[ "${KUBE_CONTEXT}" != "minikube-wbaas" ]]; then
    echo "Error: wrong kube context. Use this script only within 'minikube-wbaas'!"
    exit 1
fi
#####################################################################################
```
