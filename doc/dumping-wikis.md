# Dumping Wikis
Sometimes users request dumps of their wikibases. The Wikibase.git has some [maintenance scripts](https://gerrit.wikimedia.org/r/plugins/gitiles/mediawiki/extensions/Wikibase/+/refs/heads/master/repo/maintenance/) that can be used for this. Usually the dumps created by the maintenenace scripts shouldn't contain any sensitive data, but the resulting files should still always be treated with care.
Historically we made these available for download via [GCP buckets](https://console.cloud.google.com/storage/browser/) - for example, the bucket named `wikibase-cloud-transfer` contains data that is always publicly accessible, so this should be kept in mind. In any case, it should get discussed case by case how to make the data available and if more sensitive measures like password protection and encryption are needed.

## Examples
Here are examples of commands you can run to create JSON and XML dumps of Wikibases. Adjust `WBS_DOMAIN` as needed. Adding some kind of date indication to the output filename is recommended.
- So far running these commands took about 5-10 minutes, but this depends on the size of the wiki. If you want to measure the time it takes, prepend `time ` in front of the commands
- Both of these examples make use of `2>/dev/null` in order to suppress output messages that would otherwise malform the data
- To verify the resulting files we can utilize parser tools like `jq` and `xmllint`. They both throw errors if the data is not parseable and in addition we can check the exit code via the `$?` variable (0 means OK)
- Example of a XML dump request: https://phabricator.wikimedia.org/T371638
- Example of a JSON dump request: https://phabricator.wikimedia.org/T385154

## JSON
### Dump
```
kubectl exec -ti deployments/mediawiki-143-app-backend -- bash -c 'WBS_DOMAIN=coffeebase.wikibase.cloud php w/extensions/Wikibase/repo/maintenance/dumpJson.php 2>/dev/null' > 2025-02-26-coffeebase.wikibase.cloud.json
```

### Verify
```
jq -e . 2025-02-26-coffeebase.wikibase.cloud.json >/dev/null; echo $?
```

## XML
### Dump
```
kubectl exec -ti deployments/mediawiki-143-app-backend -- bash -c 'WBS_DOMAIN=coffeebase.wikibase.cloud php w/maintenance/dumpBackup.php --full --quiet 2>/dev/null' > 2025-02-26-coffeebase.wikibase.cloud.xml
```

### Verify
```
xmllint --noout 2025-02-26-coffeebase.wikibase.cloud.xml; echo $?
```
