## Production

Production Terraform state is held in a Google Cloud bucket.
Someone that already has access will need to add you to the `terraformers` variable access list and apply this before you can interact with production via terraform.

### Getting started

```sh
terraform init
```

Make changes to state

See the changes that will happen with:

```
terraform plan
```

And apply them with:

```
terraform apply
```

### Importing existing resources

- Import command https://www.terraform.io/docs/cli/import/index.html
- Specific docs for a gce k8s cluster https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#import

After import

> As a result of the above command, the resource is recorded in the state file. You can now run terraform plan to see how the configuration compares to the imported resource, and make any adjustments to the configuration to align with the current (or desired) state of the imported object.

#### cluster

Make a cluster.tf file with the following:

```sh
resource "google_container_cluster" "wbaas-1" {
  # (resource arguments)
}
```

Ran the import command

```sh
terraform import google_container_cluster.wbaas-1 europe-west3-a/wbaas-1
```

An added the name to the resource definitions.

#### helm deployment

https://github.com/hashicorp/terraform-provider-helm/pull/394

```
terraform import helm_release.hello-world hello-kubernetes/hello-world
terraform import helm_release.hello-custom-message hello-kubernetes/custom-message
terraform import helm_release.hello-custom-message hello-kubernetes/ingress
```