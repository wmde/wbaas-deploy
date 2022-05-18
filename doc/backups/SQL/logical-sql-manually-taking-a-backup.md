[< Back to index](../README.md)

## Manually taking logical backups

Sometimes it can be a good idea to manually take a backup. This could for example be before a tricky deployment or some risky changes to the cluster.

**!!! Do NOT schedule manual backups using the cloud console UI from google !!!**

[*During development we found out that this does not result in the same behavior as triggering it from kubectl*](https://phabricator.wikimedia.org/T307199#7926690)
### Manually taking logical backups by triggering the cronjob

```sh
kubectl create job --from=cronjob/sql-logic-backup sql-logic-backup-manual-01
```

### Manually taking backups from the restore-pod

This should normally only be done if the desired backup differs from what the cronjob would produce.

The restore-pod is configured in a similar way to the cronjob and can also take backups. For a example on how to do this manually and restoring to the primary see [Restoring secondary from primary](logical-sql-restore-secondary.md).


