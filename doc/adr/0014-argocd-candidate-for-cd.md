# 14) ArgoCD as Candidate for a Continous Deployment System {#adr_0014}
Date: 2024-12-05

## Status
accepted

## Context
Our infrastructure was using a helmfile based system for managing deployments in our local development, staging and production environments.

We have migrated the Platform UI, Platform API and redis clusters to an argocd based workflow to evaluate it as a future technological choice. We have also deployed our first new service `redis-2`.

This evaluation was undertaken to address the following key concerns and target these objectives:
- Need for consistent and reproducible deployment processes
- A desire to more comprehensively implement GitOps principles
- Challenges with the helmfile workflow including
  - Uncertainly about the quality of the helmfile software and development direction
  - Issues with each engineer maintaining a suitable deployment envionment on their development laptop
- A secure deployment system less reliant on many engineers and services with high level access to the cluster
- A desire for easy observability of if the cluster is in sync with the state defined in git
- A need for a quicker and lower friction deployment process to minimise context switching of developers 

Currently:
  - Three services have been migrated to argo
  - One new service never deployed using helmfile has been deployed to argo
  - All remaining services are using helmfile

We have experienced:
  - Deploying new images of existing services has worked smoothly and been relatively transparent to engineers
  - A sustained low cycle time and increased number of deployments for the migrated services
  - Checking the status of deployed services using the argo dashboard is convenient
  - Local development and testing of ArgoCD deployed services is less trivial than with helmfile
  - Releasing and using new helm charts for services we manage has caused engineers higher friction than helmfile
  - Deploying new services required some onboarding even for senior engineers
  - Generation of values files for the migrated redis service was confusing to engineers who didn't build this system


## Decision
We will maintain the current hybrid state for the immediate future.
Pause further service migration while we iterate on the working mode of the existing ArgoCD deployed services to make it efficient
We remain open to proposed alternative directions for continuous deployment strategies

## Consequences
### Positive
- Better visibility into deployment states
- Better alignment with GitOps principles
- Reduced manual actions and their associated variability

### Negative
- Increased complexity while we iterate on an efficient working mode
- Temporary mainentance of two parallel deployment systems
- Increased training required for team members

## Potential Risks
- Inconsistency of managing multiple deployment systems for an extended time
- Learning curve may prove frustrating to the engineering team
- Potential drift patterns for configuring different environments

## Mitigation
- Continued written documentation efforts
- Encourage all team-members to ask for help early if they encounter issues
- All team members to take part in the iterative improvement of the ArgoCD system
