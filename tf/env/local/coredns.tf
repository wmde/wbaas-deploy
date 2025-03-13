variable "coredns-custom-config" {
  type    = string
  default = <<EOF
wbaas.dev:53 {
  log
  errors
  template IN ANY {
    match "^(.*)wbaas\.dev"
    answer "{{.Name}} 60 IN CNAME ingress-nginx-controller.kube-system.svc.cluster.local"
  }
}
EOF
}

variable "coredns-volume-patch" {
  type    = string
  default = <<EOF
[
  {
    "op": "replace",
    "path": "/spec/template/spec/volumes/0/configMap/name",
    "value": "coredns-custom"
  }
]
EOF
}

data "kubernetes_config_map" "coredns" {
  metadata {
    name      = "coredns"
    namespace = "kube-system"
  }
}

resource "kubernetes_config_map" "coredns-custom" {
  metadata {
    name      = "coredns-custom"
    namespace = "kube-system"
  }

  data = {
    Corefile = "${data.kubernetes_config_map.coredns.data["Corefile"]}${var.coredns-custom-config}"
  }

  provisioner "local-exec" {
    command = "kubectl --context minikube-wbaas --namespace kube-system patch deployment/coredns --type='json' -p '${var.coredns-volume-patch}'"
  }
}
