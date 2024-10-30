# 13) Use aliases to combine ES indices {#adr_0013}

Date: ca. 2024-04-23

## Status

accepted

## Context
Using one index for each Wikibase resulted in a non-negligible memory overhead. It also resulted in a truely massive "cluster state".

## Decision
We will coerce all ElasticSearch indices to be in the same logical index and use aliases for separation.

## Consequences
We will now create a single real index using the platform api. We will create aliases referencing this real index for each new wiki.

If we change the layout of the main index we will need to create a new main index and then move the aliases over.

This will allow us to use substantially less RAM for our ElasticSearch cluster