# 10) Backup Bucket Usage {#adr_0010}

<!--
Don't forget to update the TOC in index.md when adding a new record
-->

Date: 2023-10-04

## Status

proposed

## Context

Historically the logical SQL backup mechanism in use by wikibase.cloud used a naming scheme to include a timestamp in the backup filenames (Y-m-d_HMS - 2023-10-04_185815) [1]. In addition to that, the Google Cloud bucket was configured in a way[2] that files, that are older than seven days, get deleted.

In case of failure of taking and storing complete logical backups, it may happen that these problems are not resolved within a seven day timeframe. In these situations, the team has not the option anymore to rely on logical SQL backups in case they are needed.

## Decision

- Google Cloud bucket object versioning is used instead of files with different filenames

To prevent situations like this from happening, instead of different files with timestamps, one single file is used as for the logical SQL backups. This allows the team to make use of the object versioning features that Google Cloud buckets offer [3]. A lifecycle rule that deletes non-current object versions older than seven days can be configured. This way, the last seven (or N) backups stay available, even if the last succesful backup is older than the configured retention threshold.

## Consequences

To access an backup file that is older than the current one, you have to navigate to the object version history view in the Google Cloud console, where you are still able to download any of the previous versions.



[1] https://github.com/wmde/wbaas-backup/blob/0544201f8e7503cf4f14453c40118146611baf46/src/backup.sh#L10
[2] https://github.com/wmde/wbaas-deploy/blob/ced10b0f561321b1f1f6651ecaf5b0a392157698/tf/modules/buckets/main.tf#L8
[3] https://cloud.google.com/storage/docs/control-data-lifecycles