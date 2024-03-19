# Importing resources into Opentofu

This guide is for importing resources in Opentofu,
that were created on the google cloud platform and are absent in git.

## Step 1: Import the resource state

Make sure your branch is up to date and that someone else is not poking the same environment you are working with.
Create an empty object for the resource in a opentofu file. 
example:
```
resource "google_logging_metric" "production-es-gc-time-seconds" {
    # no code
}
```
run `tofu import <resource_addr> <resource_id>` in your opentofu environment
example: `tofu import google_logging_metric.production-es-gc-time-seconds production-es-gc-time-seconds`
this will import the given resource into Opentofu state.

## Step 2: Add resource configurations

We now have the resource added to our Opentofu state, we need to add it to our configurations.
run `tofu state show <resource_addr>`, this will display the resource cofiguration.
You should copy that and paste it into a opentofu file.

## Step 3: Check that remote and opentofu state of the resource are the same

run `tofu plan` to check that the nothing is changing.

## Step 4: Deploy and push in git main

If there are no changes, run `tofu apply`, commit your change and push to main.
Note that it is important to immediately push to main after running opentofu apply.

### Note
After running `tofu plan` you may notice some insignificant change like white spaces, if that is the case, running
`tofu apply` will put everything in sync. If `tofu plan` shows resources being added or destroyed or
significantly changed? Stop and check with your peer as someone could be poking the same environment.
