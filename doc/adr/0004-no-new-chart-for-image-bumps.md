# N) No new chart cuts just for a new image version {#adr_0004}

Date: 2022-05-18

## Status

accepted

## Context

We regularly need to release new images of services we run but often the environment they run in
is not changing. They are using the same environment variables, requests and limits etc. This means
that using a new image gives us quite a high overhead and means we often try to "bunch" a load of changes
into the same image and chart cut.

## Decision

We will not make a new chart if the only thing changing is a specific image tag. Instead we will just
adjust an `image` value in a values file.
We will still cut a new chart if we want to change other things e.g. additional environment variables

## Consequences

We will have to cut fewer new charts.
There will be a smaller overhead to deploying new images.
We will have to be extra careful that we don't end up inadvertently running different image tags in.
Any users of charts will not always receive the latest updates to the images of the applications a chart is for.
different environments.
