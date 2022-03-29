[< Back to index](../README.md)

## Manually taking logical backups

Sometimes it can be a good idea to manually take a backup. This could for example be before a tricky deployment or some risky changes to the cluster.

This can be done in a few different ways.

### Manually taking logical backups by triggering the cronjob

To manually trigger the job on staging or production you can do this by finding the workload.

1. Go to "Kubernetes Engine" on https://console.cloud.google.com
2. Click on "Workloads" and select the desired cluster.
3. Find the "sql-logic-backup" workload.
4. In the top menu click the "Run now" button.
5. The job will be scheduled in a new pod with the name "manual" appended to it.
6. After the job has successfully run the backup will be available in the backup bucket with the timestamp it was taken.

### Manually taking backups from the restore-pod

This should normally only be done if the desired backup differs from what the cronjob would produce.

The restore-pod is configured in a similar way to the cronjob and can also take backups. For a example on how to do this manually and restoring to the primary see [Restoring secondary from primary](logical-sql-restore-secondary.md).


