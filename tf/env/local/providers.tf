provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube-wbaas"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}
