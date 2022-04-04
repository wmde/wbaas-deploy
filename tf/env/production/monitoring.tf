module "production-monitoring" {
  source = "./../../modules/monitoring"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  cluster_name = local.production_cluster_name
  email_group = "wb-cloud-monitoring@wikimedia.de"
}