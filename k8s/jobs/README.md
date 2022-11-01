# Introduction

The directory contains jobs, or the code to make them to be run against the kubernetes deployed services in order to perform maintenance tasks.

## loadElasticSearchAndRunAllMWJobs.sh

Uses the `ENV WBS_DOMAIN`.

This is an operation needed to either create or rebuild ES indicies for a wiki. It's important that after the index creation jobs have been run and the QueueSearchIndexBatches jobs have been added to the MediaWiki job queue that the job queue is then flushed by running all the jobs.

This internally calls `loadElasticSearchOnly.sh` and `runAllMWJobs.sh`


## loadElasticSearchOnly.sh

Uses the `ENV WBS_DOMAIN`.

This builds and submits a kubernetes job to enable ElasticSearch (Cirrus) search for a Wiki, create the necessary indicies and then submit jobs to the mediawiki jobqueue to populate them.

The job is built from a combination of `elasticSearchImportJob.yaml` and the container env variables and image are taken from the running backend api pod.

## runAllMWJobs.sh

Uses the ENV `WBS_DOMAIN`.

This builds and submits a kubernetes job to flush a given wiki's job queue in batches of a thousand.

The job is built from a combination of `runAllMWJobsJob.yaml` and the container env variables and image are taken from the running backend mediawiki pod.

## rebuildQuantityUnits.sh
Uses the ENV `WBS_DOMAIN`, `WBS_UNIT_FROM` and `WBS_UNIT_TO`

This builds and submits a kubernetes job to change unit quantities from one prefix to another.

The job is built from a combination of `rebuildQuantityUnitsJob.yaml` and the container env variables and image taken from the running backend mediawiki pod

For example run `WBS_DOMAIN="wikifcd.wikibase.cloud" WBS_UNIT_FROM="https" WBS_UNIT_TO="http"  ./rebuildQuantityUnitsJob.sh`

## resetRootSqlSecretJob.yaml
Uses no env variables from your local shell.
Should be submitted to the correct cluster using `kubectl create -f resetRootSqlSecretJob.yaml`.

This resets the root sql password from a k8s secret called `sql-root-password-old` to what is currently defined in `sql-secrets-passwords`.

## resetOtherSqlSecretsJob.yaml
Uses no env variables from your local shell.
Should be submitted to the correct cluster using `kubectl create -f resetOtherSqlSecretsJob.yaml`.

This resets the non-root sql passwords to what is currently defined in `sql-secrets-init-passwords` and `sql-secrets-passwords`.
This is done by logging in using the root sql password.

n.b. changeReplicationPasswordOnSecondary must be run immediately after this if the replication password is changed; without it
replication will break since the secondary will no longer be able to log in.

## changeReplicationPasswordOnSecondary.yaml
Uses no env variables from your local shell.

Should be submitted to the correct cluster using `kubectl create -f changeReplicationPasswordOnSecondary.yaml`.
Should be run immediately after running resetOtherSqlSecretsJob.yaml

This updates the replication password by logging into the secondary pod (not just the service which may already have become unavailable due to replication lag) using the root password.
This job will need updating if there is more than one replica server to add each additional replica server.