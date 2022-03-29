[< Back to index](../README.md)

## Restoring both primary and secondary SQL

To restore everything, make sure the restore-pod is running and get a shell.

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

### 1. Decompress the desired backup

```sh
./decompress_archive.sh /mnt/backups/mydumper-backup-2022-03-18_150902.tar.gz /tmp/decompressed-backup
```

### 2. Run the restore.sh script to restore primary

```sh
./restore.sh /tmp/decompressed-backup
```

### 3. Reset the primary binlog and show the updated position.

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

### 4. Run the restore.sh script to restore secondary

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

### 6. Confirm that the backup was successfully restored

[Follow these steps to confirm that the backup was successfully restored and replication is running correctly.](logical-sql-restore-confirmation.md)