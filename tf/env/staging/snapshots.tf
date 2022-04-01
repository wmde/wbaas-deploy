module "wbaas2-snapshots" {
  source = "./../../modules/snapshots"

  providers = {
    kubernetes = kubernetes.wbaas-2
  }

  cluster_name = local.staging_cluster_name
}
