#!/usr/bin/env bash

main() {
	local result=""

	if (($1 % 3 == 0)); then
		result=$result"Pling"
	fi
	if (($1 % 5 == 0)); then
		result=$result"Plang"
	fi
	if (($1 % 7 == 0)); then
		result=$result"Plong"
	fi
	if [[ "$result" == "" ]]; then
		result=$1
	fi

	echo $result
}

main "$1"
