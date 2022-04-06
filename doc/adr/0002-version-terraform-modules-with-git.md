# 2) Version Terraform Modules with Git

Date: 2022-03-22

## Status

proposed

## Context
We currently have some Terraform modules created and maintained by us for the purpose of reducing duplication and maintaining consistency between the local, staging and production environments.

We use the [local paths](https://www.terraform.io/language/modules/sources#local-paths) module source. This is recommened for "factoring out portions of a configuration within a single source repository". For distributing modules "across multiple configurations" the [terraform registry](https://www.terraform.io/language/modules/sources#terraform-registry) source is recommended. Other sources are available including [git](https://www.terraform.io/language/modules/sources#generic-git-repository) in order to "distribute Terraform modules internally with existing infrastructure".

Using local paths has resulted in a number of situations where changes that we wish to make only to one environment end up being accidentally applied to other environments. For example, if a new resource is added to a module for use on staging it is difficult to avoid also creating this resource on production if this module is already used in both places.

## Decision
When updating modules used by multiple environments we will explicitly version terraform modules using git tags of this repository. When creating tags the format should preferably take the form of `tf-module-<module name>-<integer>` to indicate that the tag is related to a versioned module. We will maintain a CHAMGELOG.md to make it clear what change (compared to the previous tag) this new tag introduces.

Sourceing one of these modules would look like:
```
module "production-buckets" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/buckets/?ref=tf-module-buckets-1"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  project_prefix = "wikibase-cloud"
  static_bucket_writer_account = google_service_account.api.email
  backup_bucket_object_admins = var.terraformers
}

```

## Consequences
We will be able to use explicit versions of terraform modules in different environments.
Deployers will now need to be able to access the `wbaas-deploy` git repo over ssh when running `terraform init`.
We will need to tag versions of modules after they have been merged to `main` before using them.
We may still need to refer to local paths, on staging, while actively writing and experimenting with new modules.
