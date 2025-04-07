# Increasing SQL Storage
> based on https://github.com/wbstack/deploy/blob/main/docs/services/sql.md#increasing-allocated-disk-space-replica-example

As currently we can not purely increase the storage size with our configuration alone, a two-step process is needed to increase SQL storage size.

## Preparation
- Preferably test this whole procedure in staging first [^1]
- Adjust `services.sql.storageSize` in `private.yaml` values file
- Before applying the change via helmfile, you need to delete the SQL StatefulSets first [^2]
  - `kubectl delete statefulset sql-mariadb-primary --cascade=orphan`
  - `kubectl delete statefulset sql-mariadb-secondary --cascade=orphan`

## PVC Patching
- Get an overview of relevant PVCs
  - `kubectl get pvc -l app.kubernetes.io/name=mariadb,app.kubernetes.io/instance=sql`
```
NAME                           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          VOLUMEATTRIBUTESCLASS   AGE
data-sql-mariadb-primary-0     Bound    pvc-6d4cd5ace27f6316                       65Gi       RWO            gce-pd-gkebackup-de   <unset>                 3y27d
data-sql-mariadb-secondary-0   Bound    pvc-e156991c-0d7f-4a26-9414-316482a45c91   65Gi       RWO            premium-rwo           <unset>                 685d
```

- In order to minimize potential downtime, do the following steps for mariadb-secondary storage first, and then the primary after that
1. Monitor Events via `kubectl events data-sql-mariadb-primary-0 --watch`
2. Patch the individual PVC with new storage size
    - example: `kubectl patch pvc data-sql-mariadb-primary-0 -p '{"spec":{"resources":{"requests": {"storage":"66Gi"}}}}'`
3. In the logs you should see the `FileSystemResizeSuccessful` event after a short time
```
0s (x2 over 11m)        Warning   ExternalExpanding            PersistentVolumeClaim/data-sql-mariadb-primary-0     waiting for an external controller to expand this PVC
0s (x2 over 11m)        Normal    Resizing                     PersistentVolumeClaim/data-sql-mariadb-primary-0     External resizer is resizing volume pvc-6d4cd5ace27f6316
0s (x2 over 11m)        Normal    FileSystemResizeRequired     PersistentVolumeClaim/data-sql-mariadb-primary-0     Require file system resize of volume on node
0s (x3 over 10m)        Normal    FileSystemResizeSuccessful   Pod/sql-mariadb-primary-0                            MountVolume.NodeExpandVolume succeeded for volume "pvc-6d4cd5ace27f6316" gke-wbaas-2-compute-pool-2-ee90b82c-9d7g
0s (x3 over 10m)        Normal    FileSystemResizeSuccessful   PersistentVolumeClaim/data-sql-mariadb-primary-0     MountVolume.NodeExpandVolume succeeded for volume "pvc-6d4cd5ace27f6316" gke-wbaas-2-compute-pool-2-ee90b82c-9d7g
```

## Footnotes

[^1]: A small increase in storage claim like 1GB is sufficient for testing

[^2]: The StatefulSet spec forbids patching of storage requests, so you would run into this error otherwise: `Forbidden: updates to statefulset spec for fields other than 'replicas', 'ordinals', 'template', 'updateStrategy', 'persistentVolumeClaimRetentionPolicy' and 'minReadySeconds' are forbidden`
