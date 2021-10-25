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

data "google_client_config" "wbaas-1" {
  depends_on = [google_container_cluster.wbaas-1]
}

# Defer reading the cluster data until the GKE cluster exists.
data "google_container_cluster" "wbaas-1" {
  name = local.staging_cluster_name
  depends_on = [google_container_cluster.wbaas-1]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.wbaas-1.endpoint}"
  token = data.google_client_config.wbaas-1.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.wbaas-1.master_auth[0].cluster_ca_certificate,
  )
  alias = "wbaas-1"
}

provider "mailgun" {
  api_key = "${var.mailgun_api_key}"
} 
