[< Back to index](../README.md)

# Restore SQL replica disk from snapshot

To restore, create a new disk from the snapshot, then the options are
- Use that new disk, or
- Transfer the data manually from the new disk to the existing one

Relevant links:
- [GCE docs](https://cloud.google.com/compute/docs/disks/restore-snapshot)
- [wbstack docs](https://github.com/wbstack/deploy/blob/main/docs/services/sql.md#creating-a-new-replica-from-another-snapshot-replica-or-master)

## Transfer the data manually

The following steps are mostly copied from the [wbstack documentation](https://github.com/wbstack/deploy/blob/main/docs/services/sql.md#creating-a-new-replica-from-another-snapshot-replica-or-master):

### Choose a snapshot
> Make sure you use a snapshot from a disk used in the right environment (staging vs prod)
```sh
$ gcloud compute snapshots list
NAME                                                        DISK_SIZE_GB  SRC_DISK                                                       STATUS
...
pvc-8c1ba5fc-4447-4-europe-west3-a-20220406030831-tsxp353t  60            europe-west3-a/disks/pvc-8c1ba5fc-4447-46ef-a279-656e30636897  READY
...
```

### Restore the snapshot to a temporary volume:
```sh
SNAPSHOT_NAME=pvc-8c1ba5fc-4447-4-europe-west3-a-20220406030831-tsxp353t
SNAPSHOT_SIZE=$(gcloud compute snapshots describe ${SNAPSHOT_NAME} --format=json | jq -r .diskSizeGb) && echo $SNAPSHOT_SIZE

gcloud compute disks create tmp-snapshot-restore-1 \
    --size ${SNAPSHOT_SIZE} \
    --source-snapshot ${SNAPSHOT_NAME} \
    --zone europe-west3-a \
    --type pd-ssd
```

### Create a replica with a new PVC:

In [k8s/helmfile/env/local/sql.values.yaml.gotmpl](wbaas-deploy/k8s/helmfile/env/local/sql.values.yaml.gotmpl):

- Increase the replica count so that a new PVC is created (though the pod will fail).
>```yaml
> ...
> secondary:
>   replicaCount: 2
> ...
>```

- Decrease the replica count so that the sql instance is gone, but the PVC remains.
>```yaml
> ...
> secondary:
>   replicaCount: 0
> ...
>```


### List the various k8s volumes and find the one for the new replica:

```sh
kubectl get pvc -l app.kubernetes.io/instance=sql,app.kubernetes.io/component=secondary
```

### Match that up to a gcloud disk:

> tip: you can see which disk is used in the PV that the PVC above uses by using kubectl's `describe` command

```sh
gcloud compute disks list
```

### Create a VM that has both volumes mounted:

```sh
RESTORE_TO_DISK=gke-cluster-1-fe044d2c-pvc-9e61e14c-1b8d-11eb-b104-42010a8e022c

gcloud compute instances create tmp-snapshot-restore-machine \
    --machine-type=f1-micro \
    --boot-disk-size=10GB \
    --zone=europe-west3-a \
    --disk=name=tmp-snapshot-restore-1,mode=ro,device-name=from \
    --disk=name=${RESTORE_TO_DISK},mode=rw,device-name=to
```

### Connect to the tmp machine:

```sh
gcloud compute ssh tmp-snapshot-restore-machine --zone=europe-west3-a
```

### Mount the devices and copy data:

```sh
# See the devices
lsblk
# Mount them
sudo mkdir -p /srv/source /srv/target
sudo mount -o ro,noload /dev/sdb /srv/source
sudo mount -o rw /dev/sdc /srv/target
# Copy everything over
# (~8 mins for 16GB disks (13GB full))
# (~14 mins for 30GB disks (15GB full) )
sudo rm -rf /srv/target/*
sudo cp -a /srv/source/. /srv/target/
```

**If copying from a replica:**

Scale up that replica again (should just work TM)?

**If copying from a master:**

https://dev.mysql.com/doc/mysql-replication-excerpt/5.6/en/replication-howto-slaveinit.html

Alter the replica definition so that the liveness probe is skipped, and replication doesn't start up:

```yaml
slave:
  extraFlags: --skip-slave-start
  livenessProbe:
    enabled: false
```

And scale the replica up!

Compare the list of bin logs on each the actual master and the copy.
The position to start from should be obvious as the master will have started a fresh log once out of readonly.

```sql
SHOW BINARY LOGS;
```

You can confirm the start position should be 4 with:

```sql
SHOW BINLOG EVENTS IN 'mysql-bin.000381' LIMIT 10
```

SSH to the replica, and get some details:

```sh
echo $MARIADB_MASTER_HOST
echo $MARIADB_MASTER_PORT_NUMBER
echo $MARIADB_REPLICATION_USER
echo $MARIADB_REPLICATION_PASSWORD
```

Start the mysql client and make our new replica start from that place.

```sql
CHANGE MASTER TO MASTER_HOST='XXX',
MASTER_PORT=3306,
MASTER_USER='XXX',
MASTER_PASSWORD='XXX',
MASTER_CONNECT_RETRY=10,
MASTER_LOG_FILE='XXX',
MASTER_LOG_POS=4;
```

And then start replication and check on the status:

```sql
START SLAVE;
SHOW SLAVE STATUS\G;
```

You shouldn't see any errors and the replica should catch up!

> **REMEMBER** to scale down so the replica stops and remove `--skip-slave-start` and enable the liveness check.

### Delete the temporary VM (and boot disk):

```sh
gcloud compute instances delete tmp-snapshot-restore-machine --zone=europe-west3-a
```

Now you can also delete the unused replica disk you restored the snapshot to.

### Cleaning up binlogs (saving replica space?)

https://dba.stackexchange.com/questions/41050/is-it-safe-to-delete-mysql-bin-files#41054

Remove binlogs older than 7 days:

```sql
PURGE BINARY LOGS BEFORE DATE(NOW() - INTERVAL 7 DAY) + INTERVAL 0 SECOND;
```
