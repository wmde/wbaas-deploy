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

For example run `WBS_DOMAIN="wikifcd.wikibase.cloud" WBS_UNIT_FROM WBS_UNIT_TO="http"  ./rebuildQuantityUnitsJob.sh`
