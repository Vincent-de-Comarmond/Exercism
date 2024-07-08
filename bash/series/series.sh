#!/usr/bin/env bash
die() {
	echo "$1" >/dev/stderr && exit 1
}

validate() {
	if test "${#1}" -eq 0; then
		die "series cannot be empty"
	elif test "${#1}" -lt "$2"; then
		die "slice length cannot be greater than series length"
	elif test "$2" -lt 0; then
		die "slice length cannot be negative"
	elif test "$2" -eq 0; then
		die "slice length cannot be zero"
	fi
}

main() {
	local -a result
	local i
	for ((i = 0; i <= ${#1} - $2; i++)); do
		result+=("${1:$i:$2}")
	done
	echo "${result[@]}"
}
validate "$@"
main "$@"
