## Google static bucket backup

The backups of the `sites/` folder for each environment is done by transferring the contents to a secondary backup bucket.

In production this bucket is called `wikibase-cloud-static-backup`.

In staging this bucket is called `wikibase-dev-static-backup`. 

- Buckets is backed up daily.
- Objects older than 7 days will be deleted.
- Backup buckets are stored in EUROPE-NORTH1 region.

The buckets and the job that transfers the data are defined in [modules/buckets/main.tf](../tf/modules/buckets/main.tf).
Google storage objects can be worked with from the CLI using `gsutil`. The docs for this can be found [online](https://cloud.google.com/storage/docs/gsutil).
### Downloading the backup

Download the contents of the `sites/` folder to your local machine

#### Staging
```sh
gsutil -m cp -r \
  "gs://wikibase-dev-static/sites" \
  .
```
#### Production
```sh
gsutil -m cp -r \
  "gs://wikibase-cloud-static/sites" \
  .
```

### Restoring from the backup

Copy the contents of the `sites/` folder into the static bucket.

#### Staging


```sh
gsutil -m cp -r gs://wikibase-dev-static-backup/sites gs://wikibase-dev-static/
```

#### Production

```sh
gsutil -m cp -r gs://wikibase-cloud-static-backup/sites gs://wikibase-cloud-static/
```