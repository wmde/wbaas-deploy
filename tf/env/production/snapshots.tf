module "wbaas3-snapshots" {
  source = "./../../modules/snapshots"

  providers = {
    kubernetes = kubernetes.wbaas-3
  }

  cluster_name = local.production_cluster_name
}
