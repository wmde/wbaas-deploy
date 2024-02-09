> ℹ️ Issues for this repository are tracked on [Phabricator](https://phabricator.wikimedia.org/project/board/5563/) - ([Click here to open a new one](https://phabricator.wikimedia.org/maniphest/task/edit/form/1/?tags=wikibase_cloud
))

# wbaas-deploy
Welcome to the Wikibase.Cloud deployment repository. This is used for the infrastructure as code defintions of Wikibase Cloud. It deploys a number of components from a number of differnet repositories. This includes repositories owned by both the WMDE and WBStack github organisation. 

## Overview

This repository covers a production (wikibase.cloud) and development (wikibase.dev) setup, held together with terraform, helmfile and the odd bash script.

- `bin` - Contains helpful scripts for interacting with deployments
- `charts` - Contains any custom [helm](https://helm.sh/) charts not taken from other repositories or [wbstack charts](https://github.com/wbstack/charts) / [deploy](https://github.com/wbstack/deploy)
- `gce` - Scripts for manual creation and maintenance of [Google Cloud](https://cloud.google.com/) resources (ideally will transition to terraform)
- `k8s` - Interaction with [Kubernetes](https://kubernetes.io/)
    - `k8s/helmfile` - Interaction with kubernetes via [helmfile](https://github.com/roboll/helmfile) deployments of [helm](https://helm.sh/) charts
        - `k8s/helmfile/env` - Per environment configuration (local vs prod)
- `skaffold` - Local development on top of locally deployed kubernetes using [skaffold](https://skaffold.dev/)
- `tf` - [Terraform](https://www.terraform.io/) environments
    - `tf/env` - Per environment configuration (local vs prod)

For details on how to work with this repository and set up a developing or production enviroment, see: [doc/README.md](doc/README.md)
