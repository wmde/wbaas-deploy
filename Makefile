.PHONY: help
help: # @HELP Print this message
help:
	@echo "TARGETS:"
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)    \
	    | awk '                                   \
	        BEGIN {FS = ": *# *@HELP"};           \
	        { printf "  %-20s %s\n", $$1, $$2 };  \
	    '

.PHONY: local-ca
local-ca: # @HELP Get the CA certificate that is used in the local environment
local-ca:
	kubectl get secret wikibase-local-tls -o json | jq -r '.data."ca.crt"' | base64 -d > wikibase-local-ca.crt
	realpath wikibase-local-ca.crt


.PHONY: local-ca-firefox
local-ca-firefox: # @HELP Install the minikube cluster CA certificate into your firefox profile ($FIREFOX_PROFILE)
local-ca-firefox:
	./bin/local/install-ca-cert-firefox.sh

.PHONY: minikube-start
minikube-start: # @HELP Start a local k8s cluster using minikube
minikube-start:
	minikube --profile minikube-wbaas start --kubernetes-version=1.31.2 --container-runtime=docker

.PHONY: minikube-stop
minikube-stop: # @HELP Stop the local minikube cluster
minikube-stop:
	minikube --profile minikube-wbaas stop

.PHONY: minikube-delete
minikube-delete: # @HELP Delete the local minikube cluster
minikube-delete:
	minikube --profile minikube-wbaas delete

.PHONY: minikube-pause
minikube-pause: # @HELP Pause the local minikube cluster
minikube-pause:
	minikube --profile minikube-wbaas pause -A

.PHONY: minikube-unpause
minikube-unpause: # @HELP Unpause the local minikube cluster
minikube-unpause:
	minikube --profile minikube-wbaas unpause -A

.PHONY: minikube-dashboard
minikube-dashboard: # @HELP Open the Kubernetes Dashboard for your local cluster in your browser
minikube-dashboard:
	minikube --profile minikube-wbaas dashboard

.PHONY: minikube-tunnel
minikube-tunnel: # @HELP Open a tunnel to the local cluster and expose it on an IP on the host system
minikube-tunnel:
	./bin/minikube-tunnel

.PHONY: helmfile-fetch
helmfile-fetch: # @HELP Fetch all charts defined in the Helmfile. This works across all environments
helmfile-fetch:
# local environment is used (as one is needed), and any will do
	cd ./k8s/helmfile && helmfile --environment local fetch

.PHONY: helmfile-deps
helmfile-deps: # @HELP Fetch all deps defined in the Helmfile. This works across all environments
helmfile-deps:
# local environment is used (as one is needed), and any will do
	cd ./k8s/helmfile && helmfile --environment local deps

.PHONY: helmfile-sync
helmfile-sync: # @HELP Sync all resources defined in the Helmfile. This can help if an initial apply-local didn't complete.
helmfile-sync:
	cd ./k8s/helmfile && helmfile --environment local sync

PHONY: init-%
init-local: # @HELP Initialize tf state for your local setup. This does not create any resources. It also downloads any new modules
init-staging: # @HELP Initialize tf state for staging. This does not create any resources. It also downloads any new modules
init-production: # @HELP Initialize tf state for production. This does not create any resources. It also downloads any new modules
init-%: ENV=$*
init-%:
	cd ./tf/env/$(ENV) && tofu init

.PHONY: diff-%
diff-local: # @HELP Diff the repository against the state of your local cluster
diff-staging: # @HELP Diff the repository against the state of the staging cluster
diff-production: # @HELP Diff the repository against the state of the production cluster
diff-%: ENV=$*
diff-%:
	cd ./tf/env/$(ENV) && tofu plan
	cd ./k8s/helmfile && helmfile --environment $(ENV) diff --context 5

.PHONY: apply-%
apply-local: # @HELP Apply changes in the repository to your local cluster
apply-staging: # @HELP Apply changes in the repository to the staging cluster
apply-production: # @HELP Apply changes in the repository to the production cluster
apply-%: ENV=$*
apply-%:
	cd ./tf/env/$(ENV) && tofu apply
	cd ./k8s/helmfile && helmfile --environment $(ENV) --interactive apply --context 5

diff: # @HELP Run diff for both staging and production
diff: diff-staging diff-production
apply: # @HELP Run apply for both staging and production
apply: apply-staging apply-production

.PHONY: test
test: # @HELP Run yamllint tests against the repository
test:
	yamllint --no-warnings .

skaffold-mediawiki-139: # @HELP Deploy the local mediawiki 1.39 image using skaffold
skaffold-mediawiki-143: # @HELP Deploy the local mediawiki 1.43 image using skaffold
skaffold-ui: # @HELP Deploy the local ui image using skaffold
skaffold-api: # @HELP Deploy the api image using skaffold
skaffold-queryservice: # @HELP  Deploy the local queryservice image using skaffold
skaffold-queryservice-ui: # @HELP Deploy the local queryservice-ui image using skaffold
skaffold-queryservice-updater: # @HELP Deploy the local queryservice-updater image using skaffold
skaffold-queryservice-gateway: # @HELP Deploy the local queryservice-gateway image using skaffold
skaffold-tool-cradle: # @HELP Deploy the local cradle image using skaffold
skaffold-tool-widar: # @HELP Deploy the local widar image using skaffold
skaffold-tool-quickstatements: # @HELP Deploy the local quickstatements image using skaffold
.PHONY: skaffold-%
skaffold-%: MODULE=$*
skaffold-%:
	cd ./skaffold && skaffold run --kube-context minikube-wbaas -m $(MODULE)

.PHONY: skaffold-run
skaffold-run: # @HELP Run all local modules using skaffold
skaffold-run:
	cd ./skaffold && skaffold run --kube-context minikube-wbaas

.PHONY: argo-reset-password
argo-reset-password: # @HELP Reset the admin password for the ArgoCD of the current context
argo-reset-password:
	./bin/reset-argocd-password

argo-sync-app-of-apps:
argo-sync-ui: # @HELP Sync ui in ArgoCD
.PHONY: argo-sync-%
argo-sync-%: # @HELP Sync any Application defined in ArgoCD
argo-sync-%: APP=$*
argo-sync-%:
	./bin/argocli app sync $(APP)

.PHONY: argo-sync
argo-sync: # @HELP Sync app-of-apps in ArgoCD (which contains all other Applications)
argo-sync: argo-sync-app-of-apps

.PHONY: argo-list
argo-list: # @HELP List current applications and their state in ArgoCD
argo-list:
	./bin/argocli app list

.PHONY: argo-port-forward
argo-port-forward: # @HELP Port forwards the ArgoCD UI to localhost:8080
argo-port-forward:
	kubectl -n argocd port-forward deployments/argo-cd-base-argocd-server 8080

