#!/usr/bin/env bash
main() {
	local distance=0
	local length="${#1}"
	if [[ "$#" -ne 2 ]]; then
		echo "Usage: hamming.sh <string1> <string2>" >/dev/stderr
		exit 1
	elif [[ "${#1}" -eq "${#2}" ]]; then
		for ((i = 0; i < $length; i++)); do
			if [[ "${1:i:1}" != "${2:i:1}" ]]; then ((distance++)); fi
		done
	else
		echo "strands must be of equal length" >/dev/stderr
		exit 1
	fi
	echo $distance
}

main "$@"
