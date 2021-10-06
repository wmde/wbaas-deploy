terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.5.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

resource "kubernetes_namespace" "hello-kubernetes" {
    metadata {
        name             = "hello-kubernetes"
        labels           = {
            "name" = "hello-kubernetes"
        }
    }
}

resource "helm_release" "hello-world" {
    name                       = "hello-world"
    namespace                  = kubernetes_namespace.hello-kubernetes.metadata[0].name
    chart                      = "hello-kubernetes"
    repository = "https://helmcharts.opsmx.com/"
    version                    = "1.0.0"
    wait = var.wait
    timeout = 60
}

resource "helm_release" "hello-custom-message" {
    name                       = "custom-message"
    namespace                  = kubernetes_namespace.hello-kubernetes.metadata[0].name
    chart                      = "hello-kubernetes"
    repository = "https://helmcharts.opsmx.com/"
    version                    = "1.0.0"
    wait = var.wait
    timeout = 60
}

resource "helm_release" "hello-ingress" {
    name                       = "ingress"
    namespace                  = kubernetes_namespace.hello-kubernetes.metadata[0].name
    chart                      = "hello-kubernetes"
    repository = "https://helmcharts.opsmx.com/"
    version                    = "1.0.0"
    wait = var.wait
    timeout = 60
}