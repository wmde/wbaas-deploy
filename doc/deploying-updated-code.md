# Deploying updated code

This is a simplified guide to deploying changes to components.

It does not describe how to make terraform changes or how to make
changes to charts beyond bumping the version of the image that they use.

## The big picture
To deploy new code after it has been merged in a component we currently make three steps:
 1. Build a new version of the image
 - Create a new chart
 - Use that new image and chart in the local, staging and finally production environments by making changes to this repository

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
The following section assumes that apart from the image there are no more changes that need to be made to the chart. For example, you do no

In the charts repo:
 - Pull the latest charts code
 - Bump the image version used in the chart `values.yaml` file (see the version in the last step)
 - Bump the version of the chart in `Chart.yaml`
 - Write the change log
 - Make a commit, push it to a branch and open a PR
 - Wait for CI to be green and get it merged by a colleague

 ## Testing and using the new image in all environments
 In this (wbaas-deploy) repo:
 - Make sure you are using the latest version of the code
 - Let the team know you are starting to do a deploy (mention it in mattermost)
 - run `make diff` and check there are no changes to be applied to either staging or production. If there are then this means that someone else might be deploying at the same time. It could also mean that last time someone touched the clusters they forgot to keep them in sync with thie repository. STOP DEPLOYING and communicate with the team.
 - Make a change to `helmfile.yaml` to use the new version of the chart.
 - OPTIONAL Apply this change to the local cluster with `make apply-local`
 - OPTIONAL Go and check your local cluster; see if the new change works
 - Run `make apply`
 - Respond `y` if the kubernetes changes on staging look right
 - Check if the new code is working as expected on "wikibase.dev"
 - Respond `y` if the kubernetes changes on production look right
 - Check if the new code is working as expected on "wikibase.cloud"
 - Commit your changes with something descriptive and push directly to `main`
 - get product/UX to check they are happy with the feature or change.
