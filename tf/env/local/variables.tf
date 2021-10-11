variable "sql-passwords" {
  type    = set(string)
  description = "SQL passwords to create and send to k8s as secrets"
  default = [
      "root",
      "replication",
      "api",
      "mediawiki-db-manager",
      ]
}