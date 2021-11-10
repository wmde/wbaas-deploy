.PHONY: minikube-start minikube-delete minikube-dashboard minikube-tunnel

minikube-start: 
	minikube --profile minikube-wbaas start --kubernetes-version=1.21.4

minikube-delete:
	minikube --profile minikube-wbaas delete

minikube-dashboard:
	minikube --profile minikube-wbaas dashboard

minikube-tunnel:
	./bin/minikube-tunnel

.PHONY: helmfile-deps

# Fetch all deps defined in the helmfile.
# local environment is used (as one is needed), and any will do
helmfile-deps:
	cd ./k8s/helmfile && helmfile --environment local fetch

.PHONY: local local-diff
local-diff:
	cd ./tf/env/local && terraform plan
	cd ./k8s/helmfile && helmfile --environment local diff --context 10 --skip-deps
local:
	cd ./tf/env/local && terraform apply
	cd ./k8s/helmfile && helmfile --environment local diff --interactive --context 10 --skip-deps

# Note: the staging command here actually terraform applies all of production
.PHONY: staging staging-diff
staging-diff:
	cd ./tf/env/prod && terraform plan
	cd ./k8s/helmfile && helmfile --environment staging diff --context 10 --skip-deps
staging:
	cd ./tf/env/prod && terraform apply
	cd ./k8s/helmfile && helmfile --environment staging diff --interactive --context 10 --skip-deps
