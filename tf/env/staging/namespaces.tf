resource "kubernetes_namespace" "api-job-namespace" {
  metadata {
    name = "api-jobs"
  }
}
