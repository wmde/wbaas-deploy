# Working with this Repository

This repository needs to reflect the state of any shared resources;
otherwise it will block other people from also altering those shared resources.

This means if you apply any changes to shared resources (e.g. using helmfile or Terraform) you should directly commit to `main` and push within a reasonable timeframe (say 10 mins). Shared resources are any infrastructure items that are touched by more than one person. For example, anything in our GCE project or our MailGun account. It does not include any local development clusters we may have setup.

An alternative is that you should make sure any changes to shared resources are promptly undone and then propose changes as PRs. On merging the PR the person who
merges it is responsible for applying it to the shared resources.

One shouldn't merge their own PRs, unless approved by others. Draft PRs shouldn't be merged.