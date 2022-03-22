## Logical SQL Backups

The logical sql dumps are taken by the [wbaas-backup](https://github.com/wmde/wbaas-backup) repository. This includes a CronJob, an optional Pod for recovery and a secret key for encrypting the archives.

## The CronJob

The CronJob is running daily and takes logical backups of the replica which afterwards it compresses, encrypts and sends over the the `sql-backup` bucket defined in the [bucket module](../tf/modules/buckets/main.tf)

## The restore-pod

Since the restoration required is unknown until disaster strikes, the most straight-forward way to work with the backups will for now be spinning up a pod manually and to the required operations.

This can be done by altering the `wbaas-backup.yaml.gotmpl` values file for the desired environment.

```yml
restorePodRunning: true
```

Applying the changes will start the `restore-sql-logic-backup` pod with the backup bucket mounted and the SQL root user configured.

For more information on the contents of this pod see the [wbaas-backup](https://github.com/wmde/wbaas-backup) repository.

## The backup encryption key

The backup archives are compressed and encrypted. If you need to decompress locally downloaded archives, use `kubectl` to get the contents of the `backup-openssl-key` secret for that environment.

## Download archives locally

Use the UI to download archives https://console.cloud.google.com/storage/browser/_details/wikibase-dev-sql-backup

## Restoring both primary and secondary SQL

To restore everything, we make sure the restore-pod is running and get a shell.

```sh
kubectl exec -it restore-sql-logic-backup bash
```

In a addition to this, it's a good idea to spin up `mysql` clients for both primary and the replica as we will be running some commands to reset and pause replication.

This is as of writing possible to do by running the following command.

```sh
kubectl exec -it sql-mariadb-<PRIMARY_OR_SECONDARY>-0 -- /bin/bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD}'
```

***Given that both the primary and secondary is empty we can start restoring the desired backup.***

### Restoring primary

By default, the restore-pod is configured to be pointing at the primary database for restoring. This means, we don't have to specify any env vars to start the restoration process of the primary instance.

###  1. Decompress the desired backup

```sh
./decompress_archive.sh /mnt/backups/mydumper-backup-2022-03-18_150902.tar.gz /tmp/decompressed-backup
```

###  2. Run the restore.sh script to restore primary

```sh
./restore.sh /tmp/decompressed-backup
```

###  3. Disable and reset replication

In the mysql client of **primary**

```SQL
RESET MASTER;
SHOW MASTER STATUS;
```

```SQL
MariaDB [(none)]> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      328 |              |                  |
+------------------+----------+--------------+------------------+
```

In the mysql client of **secondary**

```SQL
STOP SLAVE;
```

###  4. Run the restore.sh script to restore secondary

```sh
DB_HOST=sql-mariadb-secondary.default.svc.cluster.local ./restore.sh /tmp/decompressed-backup
```

###  5. Sync and restart replica

In the mysql client of **secondary**

```SQL
RESET SLAVE;
CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=328;
```

Start replication

```SQL
START SLAVE;
```

###  6. Confirm replication is running


In the mysql client of **secondary**

```SQL
SHOW SLAVE STATUS\G;
```

```SQL
MariaDB> SHOW SLAVE STATUS\G;
*************************** 1. row ***************************
                Slave_IO_State: Waiting for master to send event
                   Master_Host: sql-mariadb-primary
                   Master_User: replicator
                   Master_Port: 3306
                 Connect_Retry: 10
               Master_Log_File: mysql-bin.000001
           Read_Master_Log_Pos: 100252
                Relay_Log_File: mysql-relay-bin.000002
                 Relay_Log_Pos: 100479
         Relay_Master_Log_File: mysql-bin.000001
              Slave_IO_Running: Yes <--------------------------------- GOOD
             Slave_SQL_Running: Yes <--------------------------------- GOOD

```
