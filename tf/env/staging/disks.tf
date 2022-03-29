module "wbaas2-disks" {
  source = "./../../modules/disks"

  providers = {
    kubernetes = kubernetes.wbaas-2
  }
}

resource "google_compute_disk" "data-sql-mariadb-secondary" {
  name  = "data-sql-mariadb-secondary-0"
  type  = "pd-ssd"
  zone  = "europe-west3-a"
  size  = 60 # GB
  
  lifecycle {
    ignore_changes = [ labels, description ]
    prevent_destroy = true
  }
}

resource "kubernetes_persistent_volume" "data-sql-mariadb-secondary" {
  provider = kubernetes.wbaas-2
  
  metadata {
    name = "pv-data-sql-mariadb-secondary-0"
  }
  
  spec {
    capacity = {
      storage = "60Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    claim_ref {
        name = "data-sql-mariadb-secondary-0"
        namespace = "default"
    }

    persistent_volume_source {
      gce_persistent_disk {
        pd_name = google_compute_disk.data-sql-mariadb-secondary.name
      }
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "attachment" {
  name = module.wbaas2-disks.google_compute_resource_policy.wbcloud-nightly.name
  disk = google_compute_disk.data-sql-mariadb-secondary.name
}
