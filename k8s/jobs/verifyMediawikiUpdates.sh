#!/bin/bash

JOBS=$(kubectl get jobs -n adhoc-jobs -o json)

COMPLETED=$(echo $JOBS | jq -r '.items[] | select((.status.succeeded // 0) >= 1 and (.metadata.labels | has("wikiDomain"))) | "\(.metadata.name)\t\(.metadata.labels.wikiDomain)"')

INCOMPLETE=$(echo $JOBS | jq -r '.items[] | select((.status.succeeded // 0) < 1 and (.metadata.labels | has("wikiDomain"))) | "\(.metadata.name)\t\(.metadata.labels.wikiDomain)"')
# alternative query for incomplete jobs without wikiDomain label
#INCOMPLETE=$(echo $JOBS | jq -r '.items[] | select((.status.succeeded // 0) < 1) | "\(.metadata.name)"')

COMPLETED_COUNT=$(printf "%s\n" "$COMPLETED" | wc -l)
INCOMPLETE_COUNT=$(printf "%s\n" "$INCOMPLETE" | wc -l)

echo "Completed jobs:"
echo "$COMPLETED"
echo 
echo "Number of completed jobs: $COMPLETED_COUNT"
echo
echo '---'
echo
echo "Incomplete jobs:"
echo "$INCOMPLETE"
echo
echo "Number of completed jobs: $INCOMPLETE_COUNT"
