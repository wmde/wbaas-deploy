.PHONY: minikube-start minikube-stop minikube-delete minikube-dashboard minikube-tunnel init-local init-staging init-production

minikube-start:
	# version 1.21.4 is currently used in the production environments
	minikube --profile minikube-wbaas start --kubernetes-version=1.21.4

minikube-stop:
	minikube --profile minikube-wbaas stop

minikube-delete:
	minikube --profile minikube-wbaas delete

minikube-dashboard:
	minikube --profile minikube-wbaas dashboard

minikube-pause:
	minikube --profile minikube-wbaas pause -A

minikube-unpause:
	minikube --profile minikube-wbaas unpause -A

minikube-tunnel:
	./bin/minikube-tunnel

.PHONY: helmfile-deps

# Fetch all deps defined in the helmfile.
# local environment is used (as one is needed), and any will do
helmfile-deps:
	cd ./k8s/helmfile && helmfile --environment local fetch

.PHONY: diff-local apply-local
diff-local:
	cd ./tf/env/local && terraform plan
	cd ./k8s/helmfile && helmfile --environment local diff --context 5
apply-local:
	cd ./tf/env/local && terraform apply
	cd ./k8s/helmfile && helmfile --environment local --interactive apply --context 5

init:
	cd ./tf/env/${ENVIRONMENT} && terraform init
init-local:
	ENVIRONMENT=local make init
init-staging:
	ENVIRONMENT=staging make init
init-production:
	ENVIRONMENT=production make init

.PHONY: skaffold skaffold-mediawiki skaffold-ui
skaffold:
	cd ./skaffold && skaffold run -m ${MODULE}
skaffold-mediawiki:
	MODULE=mediawiki-137-fp make skaffold
skaffold-ui:
	MODULE=ui make skaffold
skaffold-api:
	MODULE=api make skaffold
skaffold-queryservice:
	MODULE=queryservice make skaffold
skaffold-queryservice-ui:
	MODULE=queryservice-ui make skaffold
skaffold-queryservice-updater:
	MODULE=queryservice-updater make skaffold
skaffold-queryservice-gateway:
	MODULE=queryservice-gateway make skaffold

.PHONY: diff apply
diff: diff-staging diff-production
apply: apply-staging apply-production

.PHONY: diff-staging apply-staging
diff-staging:
	cd ./tf/env/staging && terraform plan
	cd ./k8s/helmfile && helmfile --environment staging diff --context 5
# Note: the staging command here actually terraform applies all of staging
apply-staging:
	cd ./tf/env/staging && terraform apply
	cd ./k8s/helmfile && helmfile --environment staging --interactive apply --context 5

.PHONY: diff-production apply-production
diff-production:
	cd ./tf/env/production && terraform plan
	cd ./k8s/helmfile && helmfile --environment production diff --context 5
# Note: the production command here actually terraform applies all of production
apply-production:
	cd ./tf/env/production && terraform apply
	cd ./k8s/helmfile && helmfile --environment production --interactive apply --context 5

.PHONY: skaffold-run
skaffold-run:
	cd ./skaffold && skaffold run --kube-context minikube-wbaas

.PHONY: test
test:
	yamllint --no-warnings .
