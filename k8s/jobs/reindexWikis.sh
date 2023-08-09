#!/bin/bash

#ALL_WIKIS=$(kubectl exec -ti deployments/api-scheduler -- php artisan tinker --execute 'foreach(Wiki::get()->all() as $wiki): echo $wiki->domain.PHP_EOL; endforeach' | tail -n+2)
ALL_WIKIS=$(cat wikis.txt)

FROM='2023-08-01T00:00:00Z'
TO='2023-08-04T00:00:00Z'

echo "re-indexing all wiki edits"
echo "from: ${FROM}"
echo "to: ${TO}"
echo

for WIKI in $ALL_WIKIS; do
	date --rfc-3339=seconds

	WIKI=$(echo $WIKI | tr -d '\r')
	echo -n  "re-index? $WIKI (type "no" to skip): "
	read input
	
	if [[ "$input" != "no" ]]; then
		WBS_DOMAIN=${WIKI} WBS_FORCE_SEARCH_INDEX_FROM=${FROM} WBS_FORCE_SEARCH_INDEX_TO=${TO} ./forceSearchIndexFromTo.sh
	else
		echo "skipping $WIKI"
	fi

	echo
done

echo "DONE"
