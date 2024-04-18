# Tailscale Setup

Start by creating an appropriate ACL tag. See https://tailscale.com/kb/1236/kubernetes-operator#prerequisites

Next create an OAuth client with write permissions for devices and tag it with `tag:k8s-operator`. See https://tailscale.com/kb/1215/oauth-clients#setting-up-an-oauth-client

Populate `tailscale_client_id` and `tailscale_client_secret` in `terraform.tfvars` with the corresponding values from the newly created OAuth client.

Then add the following annotation to any services you wish to expose using Tailscale: `tailscale.com/expose: "true"`
