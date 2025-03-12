resource "kubernetes_secret" "local_tls_secret" {
  metadata {
    name = "wikibase-local-tls"
    namespace = "default"
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = file("../../../ssl-test/output/wbaas-local-test.de.crt")
    "tls.key" = file("../../../ssl-test/output/wbaas-local-test.de.key")
  }
}