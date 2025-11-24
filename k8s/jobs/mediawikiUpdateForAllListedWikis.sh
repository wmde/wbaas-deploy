#!/bin/bash
set -o pipefail

# Run MediaWiki update.php for all wikis from a list of domains.
# Usage:
# ./bin/list-wiki-domains.sh > /somewhere/domains.txt -> creates a list of domains
# ./mediawikiUpdateForAllListedWikis.sh /somewhere/domains.txt -> loops through each domain and runs mediawikiUpdate.sh

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <domains_file | ->" >&2
  exit 1
fi

INPUT="$1"

while IFS= read -r domain; do
  # Skip empty/comment lines
  [[ -z "$domain" || "$domain" =~ ^# ]] && continue

  domain=$(echo -e "$domain" | tr -d '\r')
  echo "Creating update job for wiki: $domain"
  ./mediawikiUpdate.sh "$domain"
done