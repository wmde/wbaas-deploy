resource "google_compute_disk" "data-sql-mariadb-secondary" {
  name  = "data-sql-mariadb-secondary-0"
  type  = "pd-ssd"
  zone  = "europe-west3-a"
  size  = 60 # GB
  physical_block_size_bytes = 4096
  project = local.project_id

  description = jsonencode(
            {
              "gkebackup.gke.io/created-for/volume-restore" = "vr-48b73253ea7f65d"
              "kubernetes.io/created-for/pv/name"           = "pvc-429ef8a6-8500-4c71-86cc-f027888d9f4a"
              "kubernetes.io/created-for/pvc/name"          = "data-sql-mariadb-primary-0"
              "kubernetes.io/created-for/pvc/namespace"     = "default"
            }
    )

    labels = {
        "goog-gke-volume" = ""
    }
}
