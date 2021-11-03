.PHONY: minikube-start minikube-delete minikube-dashboard minikube-tunnel

minikube-start: 
	minikube --profile minikube-wbaas start --kubernetes-version=1.21.4

minikube-delete:
	minikube --profile minikube-wbaas delete

minikube-dashboard:
	minikube --profile minikube-wbaas dashboard

minikube-tunnel:
	./bin/minikube-tunnel