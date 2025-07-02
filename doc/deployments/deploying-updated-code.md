# Deploying updated code

This is a guide to deploying changes to components.

It does not describe how to make opentofu changes or how to make
changes to charts beyond bumping the version of the image that they use.

## The big picture
To deploy new code after it has been merged in a component we currently make three steps:
 1. Build a new version of the image
 2. Create a new chart
 3. Use that new image and chart in the local, staging and finally production environments by making changes to this repository

## 1. Building a new version of the image
> [!IMPORTANT]
> Skip this section if there is an automatically built image after a commit has been merged to main

First make sure that all the code you want to deploy is merged into the main branch of the component

In the code Repo:
 - Pull the latest code of the component
 - Write the CHANGELOG for the next version
 - Select the version number, adding it to the changelog
 - Push the CHANGELOG commit to main
 - Tag the CHANGELOG commit with the version number `git tag <version>`
 - Push the tag `git push origin <tag>`

## 2. Creating a new version of that component's chart
> [!IMPORTANT]
> Only do this section if the change includes configuration of environment changes [see adr0004 for details](../adr/0004-no-new-chart-for-image-bumps.md).
> Otherwise, skip creating a new chart and update the container image used by altering the `<component-name>.values.yaml.gotmpl` file.

For creating new charts see [creating-a-new-component-chart-version.md](creating-a-new-component-chart-version.md)

## 3a. Changes to '<component-name>.values.yaml.gotmpl'
> [!IMPORTANT]
> Only do this section if there isn't an automatically generated PR for this component after a tag or commit has been pushed

- Make sure you are using the latest version of the `main` wbaas-deploy code
- Make a change to the component's `<component-name>.values.yaml.gotmpl` file to use the new version of the image in the environment you are deploying
- Commit this change to a branch, push it to github, and open a pull request

## 3b. Deploying the code to staging
 - Assign yourself to the task you are about to deploy, it should currently be in the "Waiting for Deploy to Staging" column
 - Let the team know you are planning to deploy by sharing the pull-request about to be deployed (mention it in Mattermost)
 - Make sure you are using the latest version of the `wbaas-deploy` code on the `main` branch
   ```
   git checkout main
   git pull origin main
   ```
 - Run `make diff` and check there are no changes to be applied to either staging or production. If there are then this means that someone else might be deploying at the same time. It could also mean that last time someone touched the clusters, they forgot to keep their changes in sync with this repository. ***STOP DEPLOYING*** and communicate with the team.
 - Merge the pull request you want to deploy into the `main` branch on GitHub
 - Pull the updated `main` branch locally (`git pull origin main`)
 - Run `make diff-production` and check there are no changes to the production cluster
 - Run `make apply`
 - Respond `y` if the kubernetes changes on staging look correct
 - Check if the new code is working as expected on "wikibase.dev"
 - If the previous steps fail or the PR doesn't work:
   - Communicate with the team
   - Revert the commit in GitHub
   - Pull the updated `main` branch locally (`git pull origin main`)
   - Run `make apply`
 - Move the ticket out of the deployment column and announce that deployment was completed
 - Get product/UX to check they are happy with the feature or change

 ## 3c. Deploying to Production
 - Assign yourself to the task you are about to deploy, it should currently be in the "Waiting for Deploy to Production" column
 - Let the team know you are planning to deploy by sharing the pull-request about to be deployed (mention it in Mattermost)
 - Make sure you are using the latest version of the `wbaas-deploy` code on the `main` branch
   ```
   git checkout main
   git pull origin main
   ```
 - Run `make diff` and check there are no changes to be applied to either staging or production. If there are then this means that someone else might be deploying at the same time. It could also mean that last time someone touched the clusters, they forgot to keep their changes in sync with this repository. ***STOP DEPLOYING*** and communicate with the team.
 - Merge the pull request you want to deploy into the `main` branch on GitHub
 - Pull the updated `main` branch locally (`git pull origin main`)
 - Run `make apply`
 - Respond `y` if the kubernetes changes on production look correct
 - Check if the new code is working as expected on "wikibase.cloud"
 - If the previous steps fail or the PR doesn't work:
   - Communicate with the team
   - Revert the commit in GitHub
   - Pull the updated `main` branch locally (`git pull origin main`)
   - Run `make apply`
 - Move the ticket out of the deployment column and announce that deployment was completed
 - Get product/UX to check they are happy with the feature or change
