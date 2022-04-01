module "wbaas3-disks" {
  source = "./../../modules/disks"

  providers = {
    kubernetes = kubernetes.wbaas-3
  }
}
