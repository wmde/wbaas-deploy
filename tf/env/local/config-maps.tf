module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-ui-config"

  cname_record = "sites-1.dyna.wbaas.dev."
}

resource "kubernetes_config_map" "storage-bucket" {
  metadata {
    name = "storage-bucket"
  }

  data = {
    gcs_api_static_bucket_name = "api-assets"
  }
}

resource "kubernetes_config_map" "mediawiki_host_map" {
  metadata {
    name      = "mediawiki-host-map"
  }

  data = {
    "mw_host_map.json" = jsonencode({
      "mw1.39-wbs1" = "139-app",
      "mw1.43-wbs1" = "143-app"
    })
  }
}