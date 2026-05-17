#!/usr/bin/env bash

main() {
	if [[ $1 == "total" ]]; then
		result=$(dc -e "1 2 64 ^ r - p")
	elif [[ "$1" =~ ^([1-9]|[1-5][0-9]|6[0-4])$ ]]; then
		result=$(dc -e "2 $1 1 - ^ p")
	else
		echo "Error: invalid input" >/dev/stderr
		exit 1
	fi
	echo $result
}
main "$1"
