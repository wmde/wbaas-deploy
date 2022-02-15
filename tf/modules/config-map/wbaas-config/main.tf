terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

variable "cname_record" {
  type = string
  description = "CNAME_RECORD used for ui hint"
}

resource "kubernetes_config_map" "wbaas-config" {
  metadata {
    name = "wbaas-config"
  }

  data = {
    cname_record = var.cname_record
  }

}