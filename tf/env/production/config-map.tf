module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-ui-config"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  cname_record = google_dns_record_set.cloud-dyna-A.name
}