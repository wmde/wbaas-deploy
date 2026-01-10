# Introduction

This directory contains jobs, or the code to make them, to be run against the kubernetes deployed services in order to perform maintenance tasks.

## loadElasticSearchAndRunAllMWJobs.sh

Uses the ENV `WBS_DOMAIN`

This is an operation needed to either create or rebuild ES indicies for a wiki. It's important that after the index creation jobs have been run and the QueueSearchIndexBatches jobs have been added to the MediaWiki job queue that the job queue is then flushed by running all the jobs.

This internally calls `loadElasticSearchOnly.sh` and `runAllMWJobs.sh`.


## loadElasticSearchOnly.sh

Uses the ENV `WBS_DOMAIN`

This builds and submits a kubernetes job to enable ElasticSearch (Cirrus) search for a Wiki, create the necessary indicies and then submit jobs to the mediawiki jobqueue to populate them.

The job is built from a combination of `elasticSearchImportJob.yaml`, and the container image and environment variables of the running backend api pod.

## runAllMWJobs.sh

Uses the ENV `WBS_DOMAIN`

This builds and submits a kubernetes job to flush a given wiki's job queue in batches of a thousand.

The job is built from a combination of `runAllMWJobsJob.yaml`, and the container image and environment variables of the running backend mediawiki pod.

## rebuildQuantityUnits.sh
Uses the ENV `WBS_DOMAIN`, `WBS_UNIT_FROM` and `WBS_UNIT_TO`

This builds and submits a kubernetes job to change unit quantities from one prefix to another.

The job is built from a combination of `rebuildQuantityUnitsJob.yaml`, and the container image and environment variables of the running backend mediawiki pod.

**Example Usage**
```
WBS_DOMAIN="wikifcd.wikibase.cloud" WBS_UNIT_FROM="https" WBS_UNIT_TO="http" ./rebuildQuantityUnitsJob.sh
```

## resetRootSqlSecretJob.yaml
Uses no env variables from your local shell.
Should be submitted to the correct cluster using `kubectl create -f resetRootSqlSecretJob.yaml`.

This resets the root sql password from a k8s secret called `sql-root-password-old` to what is currently defined in `sql-secrets-passwords`.

## resetOtherSqlSecretsJob.yaml
Uses no env variables from your local shell.
Should be submitted to the correct cluster using `kubectl create -f resetOtherSqlSecretsJob.yaml`.

This resets the non-root sql passwords to what is currently defined in `sql-secrets-init-passwords` and `sql-secrets-passwords`.
This is done by logging in using the root sql password.

> [!IMPORTANT]
> `changeReplicationPasswordOnSecondary.yaml` must be run immediately after this if the replication password is changed; without it replication will break since the secondary will no longer be able to log in.

## changeReplicationPasswordOnSecondary.yaml
Uses no env variables from your local shell.

Should be submitted to the correct cluster using `kubectl create -f changeReplicationPasswordOnSecondary.yaml`.
Should be run immediately after running `resetOtherSqlSecretsJob.yaml`.

This updates the replication password by logging into the secondary pod (not just the service which may already have become unavailable due to replication lag) using the root password.
This job will need updating if there is more than one replica server to add.

## singleWikiBackup.sh
Uses the ENV `DATABASE_NAME`

This creates a Persistent Volume Claim (PVC) to store the backups of single wiki databases.
It then creates a job which uses `mysqldump` to dump the db specified by `DATABASE_NAME` to `.sql` files which it stores
in the above PVC.
It takes the dump from the primary sql replica to try and ensure consistency.
Running this job repeatedly will overwrite the previous backup.
This PVC is not automatically deleted so care should be taken to remove it after use.

## singleWikiRestore.sh
Uses the ENV `DATABASE_NAME`

This works in conjunction with `singleWikiBackup.sh` to restore a database from this temporary backup.
It uses the primary replica to write to.

## addPlatformReservedUserToBotGroupForAllWikis.sh
Uses the ENV `WBS_DOMAIN`

This script loops through all wikis and run `addPlatformReservedUser.sh` on each wiki to put `PlatformReservedUser` to bot group.
Run [`list-wiki-domains`](../../bin/list-wiki-domains) first, save it to a file (for example: `domains.txt`), then run `addPlatformReservedUserToBotGroupForAllWikis.sh`.

## mediawikiUpdate.sh
Example of ENV variables to set
```sh
WBS_DOMAIN=coffeebase.wikibase.cloud
MEDIAWIKI_BACKEND_INSTANCE_LABEL=mediawiki-143
MW_VERSION=mw1.43-wbs2
```

Creates a Job that spins up it's own mediawiki pod to run the mediawiki update maintenance script (`run.php update --quick`)

- Before that script is ran the wiki gets set to read-only mode
- After it has run the dbVersion gets updated in the API
- and read-only mode gets disabled again after two minutes (nginx cache TTL)

## verifyMediaWikiUpdates.sh
Reports status for k8s Jobs kicked off via `mediawikiUpdate.sh`. Filters for them via namespace `adhoc-jobs` and the metadata label `wikiDomain`.
