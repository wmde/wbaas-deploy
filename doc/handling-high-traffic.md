# Handling High Traffic

## Introduction
Starting in 2025 Wikibase cloud started occasionally receiving a large amount of traffic.

This has caused a number of incidents:
- [Status Page: Ingress OOM](https://wmde.github.io/wikibase-cloud-status/issues/2025-02-10-nginx-oom/) / [T385969](https://phabricator.wikimedia.org/T385969)
- [Status Page: Scrapers Again](https://wmde.github.io/wikibase-cloud-status/issues/2025-07-15-scrapers-again/) / [T399439](https://phabricator.wikimedia.org/T399439) and [T400046](https://phabricator.wikimedia.org/T400046)

It's wasted quite a lot of engineering time; if you come here after dealing with this in the future, please update below.

Wasted Engineering days: 26

## Solutions in place

### robots.txt
We have a robots.txt in the [platform nginx](../k8s/helmfile/env/production/platform-nginx.nginx.conf). This helps prevent well behaved bot traffic from getting stuck in problematic parts of the site.

### rate limiting
These are set in the [ingress-nginx](../k8s/helmfile/env/production/ingress-nginx.values.yaml.gotmpl)

#### rate limits per unique IP
We rate limit per ip. That is for any single given IP we limit the rate of connections.

#### rate limits per site
We rate limit per Wikibase we host. That is there is a rate-limit for the number of connections to e.g. `coffeebase.wikibase.cloud` from any source.

#### rate limits from specific groups
When we have seen bad traffic from a given IP range we may introduce shared limits for this IP range. Initially this was for a Data Center from a specific cloud provider that was generating wildly excess traffic.

### Setting `$wgMaxExecutionTimeForExpensiveQueries`
[The config setting docs](https://www.mediawiki.org/wiki/Manual:$wgMaxExecutionTimeForExpensiveQueries) describes that this let's us set a more restrictive execution time for more expensive pages in MediaWiki. We set this in [T399804](https://phabricator.wikimedia.org/T399804)
