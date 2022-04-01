[< Back to index](../README.md)

## The `wbaas-backup` restore-pod

The **restore-pod** is meant to be a temporary maintenance pod to be installed when restoring a backup is required or when populating replicas from the primary SQL database. After the work has been done the pod should be uninstalled and disabled as it can contain sensitive data and access credentials with root privileges. 

### Install and enable the restore-pod

This can be done by altering the `wbaas-backup.yaml.gotmpl` values file for the desired environment.

```yml
restorePodRunning: true
```

Applying the changes will start the `restore-sql-logic-backup` pod with the backup bucket mounted and the SQL root user configured.

### Uninstall and disable the restore-pod

Change the `restorePodRunning` to `false` inside the `wbaas-backup.yaml.gotmpl` of the desired environment to uninstall and disable the pod. 

```yml
restorePodRunning: false
```

Applying the changes will terminate the running `restore-sql-logic-backup` pod if any.


### Backups on staging and production

In staging and production, the **restore-pod** runs with a mounted bucket where you can access previous backups.

These are available under `/mnt/backups`.

### Local backups

As we don't have access to the sql backup bucket locally the easiest way to take a backup locally is to manually enabled the **restore-pod** and take a backup.

When inside the pod it is by default configured to point to the **primary** SQL database.

You can change this by altering the `DB_HOST` variable.

```sh
DB_HOST=sql-mariadb-secondary.default.svc.cluster.local
```

Take a backup that outputs a compressed archive into `/backups`

```sh
./backup.sh
```

To copy the backup from inside the **restore-pod** to your host you can run the following command.

```sh
kubectl cp default/restore-sql-logic-backup:/backups <HOST-PATH>
```

For more information on the contents of this pod see the [wbaas-backup](https://github.com/wmde/wbaas-backup) repository.