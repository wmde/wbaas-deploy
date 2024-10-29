module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-ui-config"

  cname_record = "sites-1.dyna.wbaas.localhost."
}

resource "kubernetes_config_map" "storage-bucket" {
  metadata {
    name = "storage-bucket"
  }

  data = {
    gcs_api_static_bucket_name = "api-assets"
  }
}
