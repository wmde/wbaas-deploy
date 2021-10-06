resource "kubernetes_namespace" "hello-kubernetes" {
    metadata {
        name             = "hello-kubernetes"
        labels           = {
            "name" = "hello-kubernetes"
        }
    }
}