provider "google" {
  project     = "wikibase-cloud"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.5.0"
    }
    mailgun = {
      source = "wgebis/mailgun"
      version = "0.6.1"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
    config_context = "gke_wikibase-cloud_europe-west3-a_wbaas-1"
}

provider "mailgun" {
  api_key = "${var.mailgun_api_key}"
}