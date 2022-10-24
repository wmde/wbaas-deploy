# 5) Commit Hash based reference to UI image {#adr_0005}

Date: 2022-09-09

## Status

accepted

## Context

We need to refer to specific OCI images for use locally as well as in production environments.
The status quo is using version numbers that superficially represent \<major>.\<minor> but this has not been strictly adhered to.
These versions are specified by tagging a given commit with a version number. For example 3.14.

The current process involves writing a CHANGELOG entry with an incremented version number and the changes since the last version.
This may then be commited directly or it may be proposed as a PR for approval by another developer.

This CHANGELOG commit is then tagged (locally) and that tag pushed to github.

This then triggers the github action that runs on pushes to `main`, pull-requests and git tags to build the image.

If the commit is to either `main` or it is a git tag this is the image pushed to the container registry.
This image is tagged with the git tags. This means that commits to `main` that are not given a git tag are pushed to the container registry with no tag.

We have no consistent scheme to decide if we want to see a change as major or minor. We have incremented UI versions in inconsistent ways in the past. For example: 3.91 --> 3.92, 3.8 --> 3.90 or 3.99 --> 4.00

We have in the past spent some time waiting to have the PR to `CHANGELOG.md` approved which has increased our throughput time to production substantially. Finally we have had situations were the tagged commit (which has gone on to be built into an image) wasn't on `main`. For example if it was failed to be merged or if the "squash and merge" feature of the github UI was used.

## Decision

We stop releasing versions of the UI explicitly with tags and changelog entries. Instead we will have GitHub Actions build an OCI image on every commit and tag it with a (short 7 char) git hash before pushing it to the container registry. For clarity we will use the form `sha-abcd123`.

## Consequences
We will no longer write a changelog; to determine the changes between released versions of the UI we will need to look across the git range between the current and new image.
The reduced friction to having a new image may make it more attractive to release more regularly.
It may be easier to typo the git hash so we may want to automate places where it is due to be entered.
Without changelogs we will be more reliant on git commits to see changes over time. Therefore, we should be extra careful to write good messages.
