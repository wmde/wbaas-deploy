module "wbaas2-disks" {
  source = "./../../modules/disks"

  providers = {
    kubernetes = kubernetes.wbaas-2
  }
}
