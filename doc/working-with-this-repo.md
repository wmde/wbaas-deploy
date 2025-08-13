# Working with this Repository

### This repository needs to reflect the state of any shared resources
If it does not it will block other people from also altering those shared resources or may even result in unintentional destructive actions.

This means if you apply any changes to shared resources (e.g. using helmfile or Opentofu) the changed state needs to make it to `main` within a reasonable timeframe (say 10 mins). Shared resources are any infrastructure items that are touched by more than one person. For example, anything in our GCE project or our MailGun account. It does not include any local development clusters we may have setup.

### All changes to `main` should be prepared as PRs.

In an ideal world they should be approved by a second engineer before merging. However, this isn't always possible. If an urgent change needs to be made (e.g. to fix production) it's more important that `main` reflects the reality of the cluster than that the PR is review before merging. Engineers can always ask for review from their colleagues after merging or seek external review in these edge cases where there is no-one in the team at the time.

### Principles for merging PRs
- If one merges a PR it must be immediately deployed.
- One should try to avoid merging their own PRs until they are approved by others.
- If a PR fails to deploy it should be reverted.
- The revert can be merged without approval.
- Draft PRs shouldn't be merged without carefully checking they are now actually ready.
