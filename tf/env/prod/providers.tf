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
    helm = {
      source = "hashicorp/helm"
      version = "2.3.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
    config_context = "gke_wikibase-cloud_europe-west3-a_wbaas-1"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "gke_wikibase-cloud_europe-west3-a_wbaas-1"
  }
}
