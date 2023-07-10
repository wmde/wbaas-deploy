.PHONY: help
help: # @HELP Print this message
help:
	@echo "TARGETS:"
	@grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)    \
	    | awk '                                   \
	        BEGIN {FS = ": *# *@HELP"};           \
	        { printf "  %-20s %s\n", $$1, $$2 };  \
	    '

.PHONY: minikube-start
minikube-start: # @HELP Start a local k8s cluster using minikube
minikube-start:
	minikube --profile minikube-wbaas start --kubernetes-version=1.26.5

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
init-local: # @HELP Initialize terraform state for your local setup. This does not create any resources. It also downloads any new modules
init-staging: # @HELP Initialize terraform state for staging. This does not create any resources. It also downloads any new modules
init-production: # @HELP Initialize terraform state for production. This does not create any resources. It also downloads any new modules
init-%: ENV=$*
init-%:
	cd ./tf/env/$(ENV) && terraform init

.PHONY: diff-%
diff-local: # @HELP Diff the repository against the state of your local cluster
diff-staging: # @HELP Diff the repository against the state of the staging cluster
diff-production: # @HELP Diff the repository against the state of the production cluster
diff-%: ENV=$*
diff-%:
	cd ./tf/env/$(ENV) && terraform plan
	cd ./k8s/helmfile && helmfile --environment $(ENV) diff --context 5

.PHONY: apply-%
apply-local: # @HELP Apply changes in the repository to your local cluster
apply-staging: # @HELP Apply changes in the repository to the staging cluster
apply-production: # @HELP Apply changes in the repository to the production cluster
apply-%: ENV=$*
apply-%:
	cd ./tf/env/$(ENV) && terraform apply
	cd ./k8s/helmfile && helmfile --environment $(ENV) --interactive apply --context 5

diff: # @HELP Run diff for both staging and production
diff: diff-staging diff-production
apply: # @HELP Run apply for both staging and production
apply: apply-staging apply-production

.PHONY: test
test: # @HELP Run yamllint tests against the repository
test:
	yamllint --no-warnings .

skaffold-mediawiki-138: # @HELP Deploy the local mediawiki 1.38 image using skaffold
skaffold-mediawiki-139: # @HELP Deploy the local mediawiki 1.39 image using skaffold
skaffold-ui: # @HELP Deploy the local ui image using skaffold
skaffold-api: # @HELP Deploy the api image using skaffold
skaffold-queryservice: # @HELP  Deploy the local queryservice image using skaffold
skaffold-queryservice-ui: # @HELP Deploy the local queryservice-ui image using skaffold
skaffold-queryservice-updater: # @HELP Deploy the local queryservice-updater image using skaffold
skaffold-queryservice-gateway: # @HELP Deploy the local queryservice-gateway image using skaffold
.PHONY: skaffold-%
skaffold-%: MODULE=$*
skaffold-%:
	cd ./skaffold && skaffold run --kube-context minikube-wbaas -m $(MODULE)

.PHONY: skaffold-run
skaffold-run: # @HELP Run all local modules using skaffold
skaffold-run:
	cd ./skaffold && skaffold run --kube-context minikube-wbaas
