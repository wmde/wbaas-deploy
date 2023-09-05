# 9) Terraform style conventions {#adr_0009}

Date: 2023-05-16

## Status

accepted

## Context

When adopting Terraform as part of our infrastructure as code setup in the past, we did not settle on any code style format conventions. Since there is a built-in command to Terraform to streamline source files according to the officially recommended [style conventions](https://developer.hashicorp.com/terraform/language/syntax/style), we could make use of this to make our configuration more readable, especially for code review in pull requests.

## Decision

We use `terraform fmt` with it's defaults to auto-format files containing the Terraform Configuration Language. For now this has to be done manually - git hooks to run it automatically and/or a CI test to check for it are welcome.

## Consequences

To streamline all of the existing configuration we create a PR which formats all of the code. As mentioned above, right now it's up to the engineers to run this step on their machines before checking in Terraform code.

