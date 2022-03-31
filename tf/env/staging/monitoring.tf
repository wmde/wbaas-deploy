module "staging-monitoring" {
  source = "./../../modules/monitoring"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  cluster_name = local.staging_cluster_name
  email_group = "wb-cloud-monitoring@wikimedia.de"
}