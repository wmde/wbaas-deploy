module "wbaas3-disks" {
  source = "./../../modules/disks"

  providers = {
    kubernetes = kubernetes.wbaas-3
  }

  sql-replica-disk-name = "pvc-8c1ba5fc-4447-46ef-a279-656e30636897"
  sql-replica-pv-name   = "pvc-8c1ba5fc-4447-46ef-a279-656e30636897"
}
