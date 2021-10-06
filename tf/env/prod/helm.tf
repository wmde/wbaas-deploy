resource "helm_release" "hello-world" {
    name                       = "hello-world"
    namespace                  = kubernetes_namespace.hello-kubernetes.metadata[0].name
    chart                      = "hello-kubernetes"
    repository = "https://helmcharts.opsmx.com/"
    version                    = "1.0.0"
    timeout = 60
}

resource "helm_release" "hello-custom-message" {
    name                       = "custom-message"
    namespace                  = kubernetes_namespace.hello-kubernetes.metadata[0].name
    chart                      = "hello-kubernetes"
    repository = "https://helmcharts.opsmx.com/"
    version                    = "1.0.0"
    timeout = 60
}

resource "helm_release" "hello-ingress" {
    name                       = "ingress"
    namespace                  = kubernetes_namespace.hello-kubernetes.metadata[0].name
    chart                      = "hello-kubernetes"
    repository = "https://helmcharts.opsmx.com/"
    version                    = "1.0.0"
    timeout = 60
}