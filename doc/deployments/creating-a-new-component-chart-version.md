## Creating a new version of that component's chart
In the charts repo:
- Pull the latest charts code
- Bump the image version used in the chart's `values.yaml` file (see the version in the last step)
- Bump the version of the chart in `Chart.yaml`
- Write the change log
- Make a commit, push it to a branch and open a PR
- Wait for CI to be green and get it merged by a colleague

## Testing the chart locally before the chart is merged
This step is optional.

Test unmerged changes by:
- checking out the unmerged charts changes
- checking out the latest version of `main` branch of the component you are wanting to update
- Using skaffold to run these. See the [skaffold docs](../../skaffold/README.md)

## Preparing a change to `helmfile.yaml` for testing locally and on staging
We're going to prepare a change that will work locally and on staging.
- Make sure you are using the latest version of the `main` wbaas-deploy code
- Make a change to helmfile.yaml to use the new version of the chart in every environment except production
    - This can be done by using a construct like `'{{ if eq .Environment.Name "production" }}<old-version>{{ else }}<new-version>{{ end }}'`
- Commit this change to a branch and push it to github and open a pull request

## Testing the new chart locally
- Apply the changes to the local cluster with `make apply-local`
- Go and check your local cluster; see if the new change works

## Preparing a change to `helmfile.yaml` for production
We're going to prepare a change that will production. It will keep the local and staging changes.
- Make sure you are using the latest version of the `main` wbaas-deploy code
- Make a change to helmfile.yaml to use the new version of the chart in every environment
    - This will mean REMOVING the construct we used before like `'{{ if eq .Environment.Name "production" }}<old-version>{{ else }}<new-version>{{ end }}'` and replacing it with just the new image e.g. `<new-version>`
- Commit this change to a branch and push it to github and open a pull request
