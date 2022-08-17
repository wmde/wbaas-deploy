
resource "google_monitoring_notification_channel" "email_group" {
  display_name = "Wikibase cloud wbaas-2 Email-Notification Channel"
  type         = "email"
  labels = {
    email_address = "${var.email_group}"
  }
}
