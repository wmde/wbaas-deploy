echo "loading $WBS_DOMAIN"
JOB_NAME=$(./loadElasticSearchOnly.sh | cut -d " " -f1  )
kubectl wait --for=condition=complete $JOB_NAME --timeout=-1s
JOB_NAME=$(./runAllMWJobs.sh | cut -d " " -f1  )
kubectl wait --for=condition=complete $JOB_NAME --timeout=-1s
