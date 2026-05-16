#!/usr/bin/env bash
bail() {
	echo "$1" >/dev/stderr
	exit 1
}

validate() {
	if [[ "$1" =~ [^0-9]+ ]]; then
		bail "input must only contain digits"
	elif [ "$2" -le 0 ]; then
		bail "span must not be negative"
	elif [ "${#1}" -lt "$2" ]; then
		bail "span must be smaller than string length"
	fi
}

main() {
	local -i tmp i j product=0

	for ((i = 0; i < ${#1}; i++)); do
		tmp=1
		for ((j = 0; j < $2; j++)); do
			((i + j >= ${#1})) && tmp=0 && break || :
			((tmp = tmp * ${1:$i+$j:1}))
		done
		((product = tmp > product ? tmp : product))
	done
	echo "$product"
}
validate "$@"
main "$@"
