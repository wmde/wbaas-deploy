resource "kubernetes_namespace" "api-job-namespace" {
  metadata {
    name = "api-jobs"
  }
}

resource "kubernetes_resource_quota" "api-jobs-podquota" {
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
