[< Back to index](../README.md)

# Restore SQL replica disk from snapshot

> ## TODO 
> To restore, create a new disk from the snapshot, then the options are
> - Use that new disk, or
> - Transfer the data from the new disk to the existing one (maybe using the [restore pod](logical-sql-restore-pod.md)?)

relevant links:
- [GCE docs](https://cloud.google.com/compute/docs/disks/restore-snapshot)
- [wbstack docs](https://github.com/wbstack/deploy/blob/main/docs/services/sql.md#creating-a-new-replica-from-another-snapshot-replica-or-master)