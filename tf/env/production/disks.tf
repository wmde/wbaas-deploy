module "wbaas3-disks" {
  source = "./../../modules/disks"

  providers = {
    kubernetes = kubernetes.wbaas-3
  }
}

resource "google_compute_disk" "data-sql-mariadb-secondary" {
  name  = "pvc-8c1ba5fc-4447-46ef-a279-656e30636897"
  type  = "pd-ssd"
  zone  = "europe-west3-a"
  size  = 60 # GB
  
  lifecycle {
    ignore_changes = [ labels, description ]
    prevent_destroy = true
  }
}

resource "kubernetes_persistent_volume" "data-sql-mariadb-secondary" {
  provider = kubernetes.wbaas-3
  
  metadata {
    name = "pvc-8c1ba5fc-4447-46ef-a279-656e30636897"
  }

  spec {
    capacity = {
      storage = "60Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    claim_ref {
        name = "pvc-8c1ba5fc-4447-46ef-a279-656e30636897"
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
  name = module.wbaas3-disks.google_compute_resource_policy.wbcloud-nightly.name
  disk = google_compute_disk.data-sql-mariadb-secondary.name
}
