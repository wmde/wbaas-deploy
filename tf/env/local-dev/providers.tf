provider "kubernetes" {
  config_path    = "~/.kube/config"
    config_context = "kind-wbaas-local"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "kind-wbaas-local"
  }
}
