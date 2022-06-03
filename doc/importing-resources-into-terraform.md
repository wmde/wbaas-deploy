# Importing resources into Terraform

This guide is for importing resources in Terraform,
that were created on the google cloud platform and are absent in git.

## Step 1: Import the resource state

Make sure your branch is up to date and that someone else is not poking the same environment you are working with.
Create an empty object for the resource in a terraform file. 
example:
```
resource "google_logging_metric" "production-es-gc-time-seconds" {
    # no code
}
```
run `terraform import <resource_addr> <resource_id>` in your terraform environment
example: `terraform import google_logging_metric.production-es-gc-time-seconds production-es-gc-time-seconds`
this will import the given resource into Terraform state.

## Step 2: Add resource configurations

We now have the resource added to our Terraform state, we need to add it to our configurations.
run `terraform state show <resource_addr>`, this will display the resource cofiguration.
You should copy that and paste it into a terraform file.

## Step 3: Check that remote and terraform state of the resource are the same

run `terraform plan` to check that the nothing is changing.

## Step 4: Deploy and push in git main

If there are no changes, run `terraform apply`, commit your change and push to main.
Note that it is important to immediately push to main after running terraform apply.

### Note
After running `terraform plan` you may notice some insignificant change like white spaces, if that is the case, running
`terraform apply` will put everything in sync. If `terraform plan` shows resources being added or destroyed or
significantly changed? Stop and check with your peer as someone could be poking the same environment.
