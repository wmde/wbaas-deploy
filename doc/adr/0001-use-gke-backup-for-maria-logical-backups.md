# 1) Use GKE for MariaDB logical backups

Date: 2022-03-11

## Status

rejected (GKE Backup is still in pre-GA)

## Context

We want to take logical (i.e. something resembling sql statements) backups of our MariaDB data for the purpose of disaster recovery.
We are using Google Kubernetes Engine and this is where the MariaDB workload is running.
Google Cloud provides a new-ish [backup utility](https://cloud.google.com/kubernetes-engine/docs/add-on/backup-for-gke/how-to/protected-application).
One of the example [Backup Strategies](https://cloud.google.com/kubernetes-engine/docs/add-on/backup-for-gke/how-to/protected-application#dump-load) specifically addresses our usecase.

Currently GKE Backup is still in pre-GA mode see: https://cloud.google.com/terms/service-terms#1 which means that it shouldn't be used for personal data.

## Decision

We will take logical backups using the GKE backup utility from our replica mariadb. 

## Consequences

We will need to ensure our replica mariadb is not excessively out of date.
