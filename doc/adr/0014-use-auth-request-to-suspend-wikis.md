# 14) Use auth_request to suspend wikis {#adr_0014}

Date: 2026-11-05    

## Status

proposed

## Context
We need to be able to suspend Wikis and their associated tools when they are both automatically and manually suspended. We have at least 6 services: MediaWiki, Quickstatements, Cradle, Widar, Queryservice-UI and Queryservice that need to be suspended when a Wiki is suspended.

We need to show a user friendly HTML suspension page for suspended Wikis.

We track suspensions in the platform API.

We considered 3 initial options for handling suspensions:
- altering all 6 services at the application to check if they are suspended
- using the platform-nginx with two sub options
  - using auth_request
  - using lua
- using the gateway api

We almost immediately discounted a solution based on introducing new [Ingress][0] objects because:
- we may need to suspend many Wikis; potentially 1000s which we believe the ingress controller will not be able to handle (or the ConfigMap will become too large)
- we expect to want to deprecate our usage of Ingress

## Altering the services
Altering all 6 services would be a lot of maintenance overhead and they are in a variety of languages. Each additional service added to the platform would also require modifications first and increase that maintenance burden.

## Using Gateway API
We currently rely on Ingresses and ingress-nginx for handling incoming traffic. While Ingress is not deprecated ingress-nginx is deprecated and now maintained by 3rd parties. The natural successor to the Kubernetes [Ingress][0] api seems to be the [Gateway API][1]. We will eventually need to migrate to this. Currently the team has no experience of these APIs and has not done any due diligence to select a specific implementation of this API. We spent a morning experimenting with Kgateway, a specific implementation of this API. We made good progress but it was clear the team would need to learn a lot. We did not build a working prototype. Working in this area involves a larger blast radius and could impact things such as other traffic entering the cluster, TLS termination, DNS, Customs Domains etc.

## Using lua in platform-NGINX
Using [lua][2] feels an easy way to implement this suspension logic in NGINX. lua support is not present in the fully open-source version of NGINX. Lua support is available in [OpenResty][3] but we do not use this distribution and are unsure of its compatibility to the extent we don't want to investigate it further.


## Using auth_request in platform-NGINX
We already use [auth_request][4] functionality from NGINX to decide at the platform-nginx layer which version of MediaWiki services we will use (see [platform-nginx.nginx.conf][5]). This pattern is hard to reason with because nginx configuration is very complex to reason with. We probably want to get rid of this pattern eventually. This doesn't rely on any specific Kubernetes technology. This could allow prototyping without Kubernetes. We may well want to eventually remove the platform-nginx layer totally. In an afternoon we produced a working prototype of suspension solution based on this technology.

We considered a push model from the platform api of suspensions to a ConfigMap and concluded that this would necessitate a regularly running Job that we wanted to avoid.

We considered a pull model from the platform api to see at request time (probably with caching) if a given Wiki is suspended.

## Decision

We will build a solution based on auth_request in platform-NGINX

## Consequences
We will need a new platform API endpoint that will return information about the suspension state of a Wiki in an HTTP Header.
We will need to address any internal tooling that requires accessing Wikis.
We will need to do work on Gateway API migration in the future.
We may wish to rework this implementation at that time.

---

[0]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[1]: https://kubernetes.io/docs/concepts/services-networking/gateway/
[2]: https://docs.nginx.com/nginx/admin-guide/dynamic-modules/lua/
[3]: https://openresty.org/en/
[4]: https://nginx.org/en/docs/http/ngx_http_auth_request_module.html
[5]: https://github.com/wmde/wbaas-deploy/blob/84414be5b2600356c9c6de268cb161dcbfcaac63/k8s/helmfile/env/production/platform-nginx.nginx.conf#L345
