# 11) Handling FQDNs {#adr_0011}

<!--
Don't forget to update the TOC in index.md when adding a new record
-->

Date: 2023-10-04

## Status

accepted

## Context
(FQDN = Fully qualified domain name)

Wikibase.cloud allows it's users to create wikis with subdomains on `wikibase.cloud` or to use their own domain names. In both cases, the (resulting) FQDN gets stored in MariaDB database as-is. In August 2023 it became apparent that FQDNs with special characters (= non-ASCII), causes troubles in the system [1], one of which being k8s only allowing handling of hostnames according to RFC 1123 [2][3].

## Decision

To circumvent current and future troubles with non-ASCII domain names, from the moment the system receives the name during creation of a wiki, it gets encoded to the "Internationalized domain name" (IDN) format[4] (an encoding allowing Unicode via ASCII representation), and gets handled only in that format internally; the platform api will also output this format, alongside a decoded variant in Unicode representation.

## Consequences

- An ASCII-only representation like punycode should fix and not cause any more troubles with special characters in FQDNs
- Existing values need to be converted in the database
- Endpoint implementations in the Platform API need to be careful about actually providing both formats

- [1] - https://phabricator.wikimedia.org/T345139
- [2] - https://www.rfc-editor.org/rfc/rfc1123
- [3] - `"message": "Invalid value: \"então.carolinadoran.com\": a lowercase RFC 1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')"`
- [4] - https://en.wikipedia.org/wiki/Internationalized_domain_name
