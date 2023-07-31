#!/bin/bash

if [[ ! $(which asdf) ]]; then
	echo "asdf is missing. Please install it according to the official documentation: https://asdf-vm.com/guide/getting-started.html"
	exit 1
fi

PLUGINS=$(cat .tool-versions | awk '{print $1}')

for PLUGIN in ${PLUGINS}; do
	asdf plugin add "${PLUGIN}"
done

exit 0
