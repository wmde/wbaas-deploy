# minikube load balancer
minikube does not provision LoadBalancer service IP addresses as part of normal operation. It will only do this if you additionally run the `tunnel` command. As a result if you provision a LoadBalancer services, such as an ingress, the `EXTERNAL-IP` will continue to say `<pending>` long after creation.

```sh
minikube --profile minikube-wbaas tunnel
```

Running the tunnel on linux might require you to forward the traffic to the cluster IP of the nginx-ingress-controller. This can be done by running the following command.

```sh
EXTERNAL_IP=$(minikube --profile minikube-wbaas kubectl -- -n kube-system get service nginx-ingress-controller -o template='{{.spec.clusterIP}}')
sudo socat tcp-listen:80,reuseaddr,fork tcp:"$EXTERNAL_IP":80
```

You should then be able to access the ingress (currently on port 80), and localhost services such as http://www.wbaas.localhost/.
Most modern browsers will automatically resolve *.localhost to 127.0.0.1.
If not, you'll need to edit your hosts file.

In order to skip out this LoadBalancer stuff you can get minikube to expose the ingress directly on a port. But this will expose things on a different port and you may run into issues.

```sh
minikube --profile minikube-wbaas service -n kube-system nginx-ingress-default-backend
```

Note: There is more to making things work locally than this and we either need to setup dynamic DNS, or we need to be editing our hosts file!
