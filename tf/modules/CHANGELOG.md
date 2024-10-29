# tf-module-monitoring-26
- Add alarm on Queryservice Batches Backpressure

# tf-module-monitoring-25
- Add alarm on low number of available ES shards

# tf-module-buckets-3
- Add iam members and hmac keys for static assets in module

# tf-module-monitoring-24
- Fix log group lookup for platform summary dashboard

# tf-module-monitoring-23
- Attempt to fix logical SQL backup alerting policy (alignment period 1h -> 15m)

# tf-module-monitoring-22
- Improve logical SQL backup alerting policy (alignment period 60s -> 1h)

# tf-module-monitoring-21
- Attempt to fix the failed logical SQL backup alerting policy

# tf-module-monitoring-20
- Add alert policy for critical PV usage (Logical SQL Backup)
- Fix failed logcial SQL backup alert policy by setting duration to 24h instead of 24h 30m

# tf-module-monitoring-19
- Change prometheus-elasticsearch metric alerts to group by cluster

# tf-module-monitoring-18
- Change QueryService PV alert alignment from sum to none

# tf-module-k8s-secrets-3
- Export missing `smtp-credentials` secret to all given namespaces

# tf-module-k8s-secrets-2
- Allow consumers to export secrets used by `api` to multiple namespaces

# tf-module-monitoring-17
- Raise limit for ES metric absence alarm

# tf-module-monitoring-16
- Add alarm for ElasticSearch cluster health

# tf-module-uptime-5
- Add uptime check for cirrussearch backed mediawiki api endpoint

# tf-module-buckets-1
- Re-add retention policy on backup bucket

# tf-module-monitoring-15
- Fix repeated alerts were fired for SQL replication failing

# tf-module-k8s-secrets-1 - September 23 2022
- Remove unused Mailgun API key
# tf-module-uptime-4
- Increase duration to 5mins for alert

# tf-module-uptime-3
- Increase alignment period for alert

# tf-module-uptime-2
- Remove uptime_monitoring_email_group resource from uptime

# tf-module-monitoring-14
- Remove monitoring_email_group resource from monitoring module

# tf-module-monitoring-13
- Add user and page totals to platform summary metrics

# tf-module-uptime-1
- Add alerting for uptime checks

# tf-module-monitoring-11
- Add platform summary metrics

# tf-module-monitoring-10
- Add alert policies for critical PV usage (SQL, ES, QS)

# tf-module-monitoring-9
- Updated chart for ES monitoring, use load_1m

# tf-module-monitoring-8
- Add log based metrics derived from polling ElasticSearch

# tf-module-monitoring-7
- Increase the duration time before backup alerts 

# tf-module-monitoring-6
- Add monitoring and alerting for SQL logical backup failure.

# tf-module-monitoring-5
- Add cluster name to logging metric
- Add documentation to replication lag policy

# tf-module-monitoring-4
- Add documentation to sql replica alert

# tf-module-uptime-0
- Add modular uptime checks

# tf-module-monitoring-3
- Revert broken changes from tf-module-monitoring-1

# tf-module-monitoring-2
- Clarify alert policy names

# tf-module-monitoring-1
- Try to fix automatic resolvement of SQL replica alert

# tf-module-monitoring-0 - April 13 2022
- Add monitoring and alert for SQL replica error 1236

# tf-module-buckets-0
- Remove retention policy on backup bucket

# tf-module-k8s-secrets-0 - April 12 2022
- Add password for logical sql backups
