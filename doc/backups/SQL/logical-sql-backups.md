
[< Back to index](../README.md)

## Logical SQL Backups

The logical sql dumps are taken by the [wbaas-backup](https://github.com/wmde/wbaas-backup) repository. This includes a CronJob, an optional Pod for recovery and a secret key for encrypting the archives.

## The CronJob

The CronJob is running daily and takes logical backups of the replica which afterwards it compresses, encrypts and sends over the the `sql-backup` bucket defined in the [bucket module](../tf/modules/buckets/main.tf)

## The restore-pod

Since the restoration required is unknown until disaster strikes, the most straight-forward way to work with the backups will for now be spinning up a pod manually and to the required operations.

The restore pod is meant to be enabled when a restore or maintenance work is required, then afterwards uninstalled and disabled.

For more information how to use the `restore-pod` see the following [section](logical-sql-restore-pod.md).

## The backup encryption key

The backup archives are compressed and encrypted. If you need to decompress locally downloaded archives, use `kubectl` to get the contents of the `backup-openssl-key` secret for that environment.

## Download archives locally

Use the UI to download archives https://console.cloud.google.com/storage/browser/wikibase-dev-sql-backup