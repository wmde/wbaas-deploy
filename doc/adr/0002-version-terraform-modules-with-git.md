# 2) Version Terraform Modules with Git

Date: 2022-03-22

## Status

proposed

## Context
We currently have some Terraform modules created and maintained by us for the purpose of reducing duplication and maintaining consistency between the local, staging and production environments.

We use the [local paths](https://www.terraform.io/language/modules/sources#local-paths) module source. This is recommened for "factoring out portions of a configuration within a single source repository". For distributing modules "across multiple configurations" the [terraform registry](https://www.terraform.io/language/modules/sources#terraform-registry) source is recommended. Other sources are available including [git](https://www.terraform.io/language/modules/sources#generic-git-repository) in order to "distribute Terraform modules internally with existing infrastructure".

Using local paths has resulted in a number of situations where changes that we wish to make only to one environment end up being accidentally applied to other environments. For example, if a new resource is added to a module for use on staging it is difficult to avoid also creating this resource on production if this module is already used in both places.

## Decision
We will explicitly version terraform modules using the generic git repository method by tagging commits on the `main` branch of the `wbaas-deploy` (this) git repository. We will use tags of the form `tf-modules-<integer>`.

Module source lines of the form: `git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/k8s-secrets?ref=tf-modules-1` will be
used when calling a module.

## Consequences
We wil be able to use explicit versions of terraform modules in different environments.
Deployers will now need to be able to access the `wbaas-deploy` git repo over ssh when running `terraform init`.
We will need to tag versions of modules after they have been merged to `main` before using them.
We may still need to refer to local paths, on staging, while actively writing and experimenting with new modules.
