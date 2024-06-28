#!/usr/bin/env bash

main() {
	if [[ $1 == "total" ]]; then
		bc <<<"2^64-1"
	elif [[ "$1" =~ ^([1-9]|[1-5][0-9]|6[0-4])$ ]]; then
		bc <<<"2^($1-1)"
	else
		echo "Error: invalid input" >/dev/stderr
		exit 1
	fi
	echo $result
}
main "$1"
