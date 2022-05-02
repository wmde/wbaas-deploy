# Deploying updated code

This is a simplified guide to deploying changes to components.

It does not describe how to make terraform changes or how to make
changes to charts beyond bumping the version of the image that they use.

## The big picture
To deploy new code after it has been merged in a component we currently make three steps:
 1. Build a new version of the image
 2. Create a new chart
 3. Use that new image and chart in the local, staging and finally production environments by making changes to this repository

 ## Building a new version of the image
First make sure that all the code you want to deploy is merged into the main branch of the component

 In the code Repo:
 - Pull the latest code of the component
 - Write the CHANGELOG for the next version
 - Select the version number, adding it to the changelog
 - Push the CHANGELOG commit to main
 - Tag the CHANGELOG commit with the version number `git tag <version>`
 - Push the tag `git push origin main <tag>`

 ## Creating a new version of that component's chart
The following section assumes that apart from the image there are no more changes that need to be made to the chart. For example, you do not need to add or change any environment variables added to the running deployments.

In the charts repo:
 - Pull the latest charts code
 - Bump the image version used in the chart `values.yaml` file (see the version in the last step)
 - Bump the version of the chart in `Chart.yaml`
 - Write the change log
 - Make a commit, push it to a branch and open a PR
 - Wait for CI to be green and get it merged by a colleague

## Testing the chart locally before the chart is merged
This step is optional.

Test unmerged changes by:
- checking out the unmerged charts changes
- checking out the latest version of `main` branch of the component you are wanting to update
- Using skaffold to run these. See the [skaffold docs](../skaffold/README.md)

## Preparing a change to `helmfile.yaml` for testing locally and on staging
We're going to prepare a change that will work locally and on staging.
 - Make sure you are using the latest version of the `main` wbaas-deploy code
 - Make a change to helmfile.yaml to use the new version of the chart in every environment except production
   - This can be done by using a construct like `'{{ if eq .Environment.Name "production" }}<old-version>{{ else }}<new-version>{{ end }}'`
 - Commit this change to a branch and push it to github and open a pull request


## Testing the new chart locally, locally
 - Apply the changes to the local cluster with `make apply-local`
 - Go and check your local cluster; see if the new change works

## Deploying the code to staging
 - Assign yourself to the task you are about to deploy, should currently be in "Deploy to Staging"
 - Let the team know you are planning to deploy by sharing the pull-request about to be deployed (mention it in mattermost)
 - Make sure you are using the latest version of the `main` wbaas-deploy code
 - run `make diff` and check there are no changes to be applied to either staging or production. If there are then this means that someone else might be deploying at the same time. It could also mean that last time someone touched the clusters they forgot to keep them in sync with thie repository. STOP DEPLOYING and communicate with the team.
 - Rebase the pull request you want to deploy onto main. e.g. `git rebase add-concept-uri-staging`
 - Run `make diff-production` and check there are no changes to the production cluster.
 - Run `make apply`
 - Respond `y` if the kubernetes changes on staging look right
 - Check if the new code is working as expected on "wikibase.dev"
 - Push the commits you just deployed into `main` with `git push`
 - Close the PR
 - Move the ticket out of the deployment column and announce that deployment was completed
 - Get product/UX to check they are happy with the feature or change.

 ## Preparing a change to `helmfile.yaml` for production
We're going to prepare a change that will production. It will keep the local and staging changes.
 - Make sure you are using the latest version of the `main` wbaas-deploy code
 - Make a change to helmfile.yaml to use the new version of the chart in every environment
   - This will mean REMOVING the construct we used before like `'{{ if eq .Environment.Name "production" }}<old-version>{{ else }}<new-version>{{ end }}'` and repacing it with just the new image e.g. `<new-version>`
 - Commit this change to a branch and push it to github and open a pull request


 ## Deploying to Production
 - Assign yourself to the task you are about to deploy, should currently be in "Deploy to production"
 - Let the team know you are planning to deploy by sharing the pull-request about to be deployed (mention it in mattermost)
 - Make sure you are using the latest version of the `main` wbaas-deploy code
 - run `make diff` and check there are no changes to be applied to either staging or production. If there are then this means that someone else might be deploying at the same time. It could also mean that last time someone touched the clusters they forgot to keep them in sync with thie repository. STOP DEPLOYING and communicate with the team.
 - Rebase the pull request you want to deploy onto main. e.g. `git rebase add-concept-uri-scheme-production`
 - Run `make diff-staging` and check there are no changes to the staging cluster.
 - Run `make apply`
 - Respond `y` if the kubernetes changes on production look right
 - Check if the new code is working as expected on "wikibase.cloud"
 - Push the commits you just deployed into `main` with `git push`
 - Close the PR
 - Move the ticket out of the deployment column and announce that deployment was completed
 - Get product/UX to check they are happy with the feature or change.
