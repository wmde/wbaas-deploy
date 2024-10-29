## Staging

Staging Opentofu state is held in a Google Cloud bucket.
Someone that already has access will need to add you to the `terraformers` variable access list and apply this before you can interact with staging via `tofu`.

### Getting started

```sh
tofu init
```

Make changes to state

See the changes that will happen with:

```sh
tofu plan
```

And apply them with:

```sh
tofu apply
```

### Importing existing resources

- Import command https://www.terraform.io/docs/cli/import/index.html
- Specific docs for a gce k8s cluster https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#import

After import

> As a result of the above command, the resource is recorded in the state file. You can now run `tofu plan` to see how the configuration compares to the imported resource, and make any adjustments to the configuration to align with the current (or desired) state of the imported object.