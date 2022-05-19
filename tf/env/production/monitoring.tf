module "production-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-6"
  
  providers = {
    kubernetes = kubernetes.wbaas-3
  }

  cluster_name = local.production_cluster_name
  email_group = "wb-cloud-monitoring@wikimedia.de"
}