#!/bin/bash

JOBS=$(kubectl get jobs -n adhoc-jobs -o json)

COMPLETED=$(echo $JOBS | jq -r '.items[] | select((.status.succeeded // 0) >= 1 and (.metadata.labels | has("wikiDomain"))) | "\(.metadata.name)\t\(.metadata.labels.wikiDomain)"')

INCOMPLETE=$(echo $JOBS | jq -r '.items[] | select((.status.succeeded // 0) < 1 and (.metadata.labels | has("wikiDomain"))) | "\(.metadata.name)\t\(.metadata.labels.wikiDomain)"')
# alternative query for incomplete jobs without wikiDomain label
#INCOMPLETE=$(echo $JOBS | jq -r '.items[] | select((.status.succeeded // 0) < 1) | "\(.metadata.name)"')

COMPLETED_COUNT=$(echo "$COMPLETED" | grep -cv '^[[:space:]]*$')
INCOMPLETE_COUNT=$(echo "$INCOMPLETE" | grep -cv '^[[:space:]]*$')

echo "Completed jobs:"
echo "$COMPLETED"
echo 
echo "Incomplete jobs:"
echo "$INCOMPLETE"
echo
echo '---'
echo
echo "Number of completed jobs: $COMPLETED_COUNT"
echo
echo "Number of incomplete jobs: $INCOMPLETE_COUNT"
echo
