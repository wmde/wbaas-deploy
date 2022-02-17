module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-ui-config"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  cname_record = google_dns_record_set.dev-dyna-A.name
}