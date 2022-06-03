variable "cluster_name" {
  type = string
  description = "Name of the cluster"
}

variable "email_group" {
  type = string
  description = "Google Group that will receive alerts"
}

variable "elasticsearch_metrics" {
  type    = set(string)
  description = "Metrics to look for in the json payload"
  default = [
      "heap.percent",
      "ram.percent",
      "disk.used_percent",
      "load_5m"
      ]
}