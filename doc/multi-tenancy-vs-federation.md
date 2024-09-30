Wikibase Cloud's uses a [Multitenancy](https://en.wikipedia.org/wiki/Multitenancy) approach to many of its services.

This is done to keep the cost of running each individual Wikibase low. It also reduces the costs of managing the releases of new features.

We use a single instance of Blazegraph for the Wikibase instances we manage. We use the namespace feature to provide segregation of the tenant's data at the database level. We have implemented a custom service to route queries to the correct namespace. We have implemented a customer updater pipeline to allow the queryservice to be updated efficiently. This multi-tenant model is not [federation](https://www.mediawiki.org/wiki/Wikibase/Federation).

We do allow federated querying between Wikibase Cloud instances. We also allow federated querying to Wikidata. We also allow federated querying to the same 3rd party endpoints that Wikidata allows.

We use a single ElasticSearch cluster for all of our Wikibases. In the first half of 2024 moved the data for each Wikibase even closer together and placed them all in the same indices. This substantially reduced costs we were facing due to the overheads ElasticSearch has for each index. Sharing a single cluster or even a single index is not federation.

Finally, relevant to the topic of federation we host wikibase.world. This is a community run project that describes itself as follows:
> _**[Wikibase World](https://wikibase.world/wiki/Item:Q3 "Item:Q3")**_ is a collaborative database of the Wikibase ecosystem, including individual Wikibase instances, itself running on Wikibase.

This provides a space for people to map Wikibases together therefore making them more interoperable. This makes it easier for people to write federated queries.
