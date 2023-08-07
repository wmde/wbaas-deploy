resource "kubernetes_namespace" "api-job-namespace" {
  provider = kubernetes.wbaas-2

  metadata {
    name = "api-jobs"
  }
}

resource "kubernetes_resource_quota" "api-jobs-podquota" {
  provider = kubernetes.wbaas-2
  
  metadata {
    name      = "api-jobs-podquota"
    namespace = kubernetes_namespace.api-job-namespace.metadata[0].name
  }
  spec {
    hard = {
      pods = 8
    }
    scopes = ["BestEffort"]
  }
}

resource "kubernetes_namespace" "adhoc-job-namespace" {
  provider = kubernetes.wbaas-2

  metadata {
    name = "adhoc-jobs"
  }
}

resource "kubernetes_resource_quota" "adhoc-jobs-podquota" {
  provider = kubernetes.wbaas-2

  metadata {
    name      = "api-jobs-podquota"
    namespace = kubernetes_namespace.api-job-namespace.metadata[0].name
  }
  spec {
    hard = {
      pods = 4
    }
    scopes = ["BestEffort"]
  }
}
