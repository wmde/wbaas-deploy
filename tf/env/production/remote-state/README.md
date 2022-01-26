# terraform-state

This directory is for initial setup of Google Cloud for use with Terraform for production.

After deploying these resources you'll then use the `production` environment directory.

Pattern used here was taken from https://stackoverflow.com/a/48362341/4746236

And once setting this up and running `init` for production, you'll want to import the state that you created here.

```sh
terraform import google_storage_bucket.tf-state-production wikibase-cloud-tf-state-production
terraform import google_storage_bucket_iam_member.tf-state-iam-member "wikibase-cloud-tf-state-production roles/storage.objectAdmin user:adam.shorland@wikimedia.de"
```

However, this will fail to run before your first `apply` because some resources that terraform expects to exist don't. For example the kubernetes cluster
that the terraform provider wants to use. To work around this comment out the references to the resources named `google_storage_bucket.tf-state-production` and `google_storage_bucket_iam_member.tf-state-production-iam-member` in order to run your first `apply`.

You can then uncomment these and run the import commands detailled above.