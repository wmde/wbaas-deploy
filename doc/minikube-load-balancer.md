# minikube load balancer
minikube does not provision LoadBalancer service IP addresses as part of normal operation. It will only do this if you additionally run the `tunnel` command. As a result if you provision a LoadBalancer services, such as an ingress, the `EXTERNAL-IP` will continue to say `<pending>` long after creation.

```sh
minikube --profile minikube-wbaas tunnel
```

Running the tunnel on linux might require you to forward the traffic to the cluster IP of the nginx-ingress-controller. This can be done by running the script `/bin/minikube-tunnel`
You should then be able to access the ingress (currently on port 443), and localhost services such as www.wbaas.dev, mailhog.wbaas.dev, etc.
`wbaas.dev` is registered by WMDE and is set up to resolve to `127.0.0.1`. If not, you'll need to edit your hosts file.

> [!NOTE]
> Previously `*.wbaas.localhost` was used for this purpose

> [!NOTE]
> In case the setup can be modified to use a dedicated static ip for the local minikube cluster, wbaas.dev could point to that one instaed of 127.0.0.1 and then the minikube ingress addon can be used: https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/
