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
      pods = 2
    }
    scopes = ["BestEffort"]
  }
}


resource "kubernetes_namespace" "adhoc-job-namespace" {
  metadata {
    name = "adhoc-jobs"
  }
}

resource "kubernetes_resource_quota" "adhoc-jobs-podquota" {
  metadata {
    name      = "adhoc-jobs-podquota"
    namespace = kubernetes_namespace.adhoc-job-namespace.metadata[0].name
  }
  spec {
    hard = {
      pods = 1
    }
    scopes = ["BestEffort"]
  }
}
