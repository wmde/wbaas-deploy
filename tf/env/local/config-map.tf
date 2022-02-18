module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-ui-config"
  
  cname_record = "sites-1.dyna.wbaas.localhost."
}

