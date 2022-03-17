module "production-disks" {
  source = "./../../modules/disks"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
}
