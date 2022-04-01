[< Back to index](../README.md)

## Restoring secondary from primary

To bring a replica up, make sure the restore-pod is running and get a shell.

```sh
kubectl exec -it restore-sql-logic-backup bash
```

In a addition to this, it's a good idea to spin up `mysql` clients for both primary and the replica as we will be running some commands to reset and pause replication.

This is as of writing possible to do by running the following command.

```sh
kubectl exec -it sql-mariadb-<PRIMARY_OR_SECONDARY>-0 -- /bin/bash -c 'mysql -u root -p${MARIADB_ROOT_PASSWORD}'
```

## 1. Pause writing to the primary

On the **primary**

```
FLUSH TABLES WITH READ LOCK;
SET GLOBAL read_only = ON;
```

The wikis should show a notice about the site being locked if successful and MediaWiki picked it up.

`Warning: The database has been locked for maintenance, so you will not be able to publish your edits right now.`

This will prevent any further edits until the lock is released.

## 2. Take a backup to populate secondary with

Inside the **restore-pod**, make sure `DB_HOST` is set to the primary.

```sh
notroot@restore-sql-logic-backup:/app$ echo $DB_HOST
sql-mariadb-primary.default.svc.cluster.local
```

Take the backup in the **restore-pod**

```sh
./backup.sh
```

This will produce an compressed and encrypted archive in `/backups` and the raw backup inside `/tmp/backup-<CURRENT-DATE>/`

You can decide to either decompress the archive or directly restore from the raw output.

## 3. Restore to the secondary

Update the `DB_HOST` to point to the replica you want to populate. 

```sh
DB_HOST=sql-mariadb-secondary.default.svc.cluster.local
```

Run the `restore.sh` script in the **restore-pod**

```
./restore.sh <FOLDER CONTAINING BACKUP>
```

Watch the output for any warnings or critical errors.


## 4. Update and start replication on secondary

On the **primary**

```sql
SHOW MASTER STATUS;
```

*Example output:*

```sql
MariaDB [(none)]> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |   170969 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.000 sec)

```

We now need to tell the secondary to start at this position.

On the **secondary** update the position and log file.

```sql
RESET SLAVE;
CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=170969;
```

*Example output*

```sql
MariaDB [(none)]> CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=170969;
Query OK, 0 rows affected (0.010 sec)
```

We can now start the replication again on **secondary** again.

```sql
START SLAVE;
```

### 5. Confirm that the backup was successfully restored

[Follow these steps to confirm that the backup was successfully restored and replication is running correctly.](logical-sql-restore-confirmation.md)

### 6. Release the write lock on primary

After everything seems to be running OK we can now release the write-lock.

On the **primary**

```sql
SET GLOBAL read_only = OFF;
```

*Example output*
```sql
MariaDB [(none)]> SET GLOBAL read_only = OFF;
Query OK, 0 rows affected (0.000 sec)
```

