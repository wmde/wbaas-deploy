resource "kubernetes_config_map" "wbaas" {
  metadata {
    name = "wbaas-config"
  }

  data = {
    cname_record = var.cname_record
  }

}

output "cname_record" {  value = var.cname_record }