module "wbaas2-disks" {
  source = "./../../modules/disks"

  providers = {
    kubernetes = kubernetes.wbaas-2
  }

  sql-replica-disk-name = "data-sql-mariadb-secondary-0"
  sql-replica-pv-name   = "pv-data-sql-mariadb-secondary-0"
}
