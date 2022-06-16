# Deploying updated code

This is a guide to deploying changes to components.

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
For creating new charts see [creating-a-new-component-chart-version.md](creating-a-new-component-chart-version.md)
*Note:* Only do this section if the change includes configuration of environment changes [see adr0004 for details.](../adr/0004-no-new-chart-for-image-bumps.md)
Otherwise, skip creating a new chart and update the docker image used by altering the values file.

 ## Changes to '<component-name>.values.yaml'
- Make sure you are using the latest version of the `main` wbaas-deploy code
- Make a change to the component's `values.yaml` file to use the new version of the image in the environment you are deploying
- Commit this change to a branch and push it to github and open a pull request

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
