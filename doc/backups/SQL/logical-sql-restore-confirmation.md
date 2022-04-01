[< Back to index](../README.md)

## Confirming that the backup was succesfully restored.

After the backup was restored we need to confirm that replication is succesfully running and that the database users can connect to their databases with the correct privileges.

###  1. Confirm replication is running

In the mysql client of **secondary**

```sql
SHOW SLAVE STATUS\G;
```

```sql
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

There shouldn't be any errors in the following fields if the secondary was just reset.

```sql
                 Last_IO_Errno: 0
                 Last_IO_Error: 
                Last_SQL_Errno: 0
                Last_SQL_Error: 

```

### 2. Confirm MariaDB privileges is correctly set 

After the backup has been restored and replication seems to be running correctly.

1. Visit the ui to confirm that it can connect to the database using the api user.
2. Visit a wiki and make sure it can connect to the database using that wikis user.

In case it either of the two cases cannot connect, it might be required to [flush](https://mariadb.com/kb/en/flush/) the privileges and make them reload from the grant tables.

On the **primary** and **secondary**

```sql
FLUSH PRIVILEGES;
```