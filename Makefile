.PHONY: minikube-start minikube-stop minikube-delete minikube-dashboard minikube-tunnel

minikube-start:
	minikube --profile minikube-wbaas start --kubernetes-version=1.21.4

minikube-stop:
	minikube --profile minikube-wbaas stop

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

.PHONY: diff-local apply-local
diff-local:
	cd ./tf/env/local && terraform plan
	cd ./k8s/helmfile && helmfile --environment local diff --context 5 --skip-deps
apply-local:
	cd ./tf/env/local && terraform apply
	cd ./k8s/helmfile && helmfile --environment local --interactive apply --context 5 --skip-deps

# Note: the staging command here actually terraform applies all of production
.PHONY: diff-staging apply-staging
diff-staging:
	cd ./tf/env/prod && terraform plan
	cd ./k8s/helmfile && helmfile --environment staging diff --context 5 --skip-deps
apply-staging:
	cd ./tf/env/prod && terraform apply
	cd ./k8s/helmfile && helmfile --environment staging --interactive apply --context 5 --skip-deps

.PHONY: skaffold-run
skaffold-run:
	cd ./skaffold && skaffold run --kube-context minikube-wbaas
