# Disk snapshots
List of disks that should get snapshots regularly:
- sql-mariadb-secondary

## Initial setup
In order to set scheduled snapshots up, you can run the script located in `bin/gce-attach-snapshot-schedule`. This will compose a `gcloud` command you can run to attach the existing snapshot policy to that disks. The snapshot policy is defined in terraform (`tf/modules/disks/policies.tf`).

## Example

```
$ bash bin/gce-attach-snapshot-schedule 
context: 'gke_wikibase-cloud_europe-west3-a_wbaas-2'
disk:    'data-sql-mariadb-secondary-0' (located in 'europe-west3-a')
policy:  'wbcloud-nightly-west-to-north-7d-1'

> gcloud compute disks add-resource-policies data-sql-mariadb-secondary-0 --zone=europe-west3-a --resource-policies=wbcloud-nightly-west-to-north-7d-1

$ gcloud compute disks add-resource-policies data-sql-mariadb-secondary-0 --zone=europe-west3-a --resource-policies=wbcloud-nightly-west-to-north-7d-1
```