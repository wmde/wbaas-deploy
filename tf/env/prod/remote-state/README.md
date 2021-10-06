# terraform-state

This directory is for initial setup of Google Cloud for use with Terraform for production.

After deploying these resources you'll then use the `prod` environment directory.

Pattern used here was taken from https://stackoverflow.com/a/48362341/4746236

And once setting this up and running `init` for production, you'll want to import the state that you created here.

```sh
terraform import google_storage_bucket.tf-state wikibase-cloud-tf-state-prod
terraform import google_storage_bucket_iam_member.tf-state-iam-member "wikibase-cloud-tf-state-prod roles/storage.objectAdmin user:adam.shorland@wikimedia.de"
```