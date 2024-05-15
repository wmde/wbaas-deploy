# 12) Stop versioning terraform modules with git {#adr_0012}

Date: 2024-05-06

## Status

accepted

## Context
After versioning OpenTofu (previously Terraform) modules with [git](https://www.terraform.io/language/modules/sources#generic-git-repository) for a couple of years we have found it adds a large amount of friction to the process. We did not implement some convenience scripts for handing the process of releasing the modules. Instead we manually had to follow the process of:
- trying a new module either locally or on staging while using a local path but not committing it
- commiting the changes to that module
- waiting for review on the module change (which were themselves hard to test without the reviewer also using a local path)
- merging the change and attempting to not forget to bump the module numbers
- tagging with the correct new module number
- committing a module bump for staging
- deploying the staging change
- committing a version bump for production
- deploying the production change

## Decision
We wil sunset this process when we make changes to modules. Instead we will refer to the most recent version of the module in production using [local paths](https://www.terraform.io/language/modules/sources#local-paths).
Unless we are testing a new module on staging before updating to production we will also refer to this version on staging using [local paths](https://www.terraform.io/language/modules/sources#local-paths).
To test new modules on staging we will temporarily duplicate the module into `tf/modules-next/<module name>` and refer to that on staging using [local paths](https://www.terraform.io/language/modules/sources#local-paths).

## Consequences
When we update tf modules we then use this now procedure.

The steps will then looks as follows:
- Copy production module to "next" folder
- Reference the "next" modules folder locally in staging module reference (and run tf init)
- Make proposed changes
- Commit and open PR
- After review merge
- Move next folder to overwride "main folder" (i.e. deleteing the "next" folder too)
- adjust both staging and production modules references to the "main folder" (and run tf-init)
- Commit and open PR
- Merge to deploy to staging 

We will create some simple scripts to aid the process of creation of the "next" module, cleaning it up after moving it to production and checking on deploy that we have not been using a testing module for too long.


