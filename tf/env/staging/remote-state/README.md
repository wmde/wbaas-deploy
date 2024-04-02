# terraform-state

This directory is for initial setup of Google Cloud for use with Opentofu for Staging.

After deploying these resources you'll then use the `staging` environment directory.

Pattern used here was taken from https://stackoverflow.com/a/48362341/4746236

And once setting this up and running `init` for staging, you'll want to import the state that you created here.

This is possible with the following commands

```sh
tofu import google_storage_bucket.tf-state wikibase-cloud-tf-state-staging
tofu import google_storage_bucket_iam_member.tf-state-iam-member "wikibase-cloud-tf-state-staging roles/storage.objectAdmin user:adam.shorland@wikimedia.de"
```

However, this will fail to run before your first `apply` because some resources that tofu expects to exist don't. For example the kubernetes cluster
that the tofu provider wants to use. To work around this comment out the references to the resources named `google_storage_bucket.tf-state` and `google_storage_bucket_iam_member.tf-state-iam-member` in order to run your first `apply`.

You can then uncomment these and run the import commands detailled above.