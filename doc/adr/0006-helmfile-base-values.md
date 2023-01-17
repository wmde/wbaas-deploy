# 6) Production as the configuration base case for helmfile values {#adr_0006}

Date: 2023-01-17

## Status

accepted

## Context

We deploy Wikibase Cloud to different environments, i.e. `production` and `staging`.
It's also possible to run the setup on dev machines using the `local` environment.
Configuration values across these environments has been heavily duplicated.
This makes it easy to miss updates for a certain environment, or inadvertently deploying changes that weren't meant to be deployed to a certain environment.

This is why we've been looking for ways to DRY these value files up.

While the [most straight forward way][helmfile-docs] of de-duplicating values is easy to do, it creates one-off hierarchy patterns for each helmfile release, and every change to be done requires understanding yet another ad-hoc solution.


Instead, we'd like to end up in a situation where every helmfile release uses the same pattern, making it obvious how and where to apply pending changes.

## Decision

Instead of defining [a common set of values for a service in a `base` case][helmfile-docs], and then apply per-environment changes on top of this base case, __we want to always use the values for production as the base case__ and then define overrides per staging and production.

### Exception: image tag values

Overrides for `image.tag` values should be defined for every environment, even if they are duplicated.
This allows us to automatically update these values through scripts, and also creates a reasonably simple paper trail of what version has been running in which environment.

[helmfile-docs]: https://github.com/helmfile/helmfile/blob/main/docs/writing-helmfile.md#release-template--conventional-directory-structure

### Example

Such a layout would look like this:

```
.
└── env
    ├── local
    │    └── app.values.yml.gotmpl <-- local overrides only, plus image tag if applicable
    ├── production
    │    └── app.values.yml.gotmpl <-- base case, containing a full configuration
    └── staging
        └── app.values.yml.gotmpl <-- staging overrides only, plus image tag if applicable
```

Example values for a hypothetical app could look like this:

```yml
# production defines a full configuration
image:
  tag: 1.2.0
port: 8080
replicas: 4 
forceSsl: true
```

```yml
# staging reduces the number of replicas
image:
  tag: 1.2.0
replicas: 1 
```

```yml
# local runs a newer version, reduces the number of replicas
# and disables SSL
image:
  tag: 1.2.1
replicas: 1
forceSsl: false
```

## Consequences

Using this approach has the following benefits:
- We can apply the same pattern everywhere, making it easier for people to review and change configuration values
- When making mistakes, unwanted changes to production are the least likely scenario

Using this approach has the following downsides:
- The amount of code duplication is not as low as it could be, it's still much better than keeping a file per environment though
