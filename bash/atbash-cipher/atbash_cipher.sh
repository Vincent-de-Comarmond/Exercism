#!/usr/bin/env bash
decode() {
	local result=""
	while read -r -n1 char; do
		result=$result$(sub "$char")
	done <<<"$*"
	echo "$result"
}

encode() {
	local idx=0
	local result=""
	while read -r -n1 char; do
		[ "$char" == "" ] && continue
		[ "$idx" -eq 5 ] && result=$result" " && idx=0
		result=$result$(sub "$char")
		((idx++))
	done <<<"$*"
	echo "$result"
}

sub() {
	tr abcdefghijklmnopqrstuvwxyz zyxwvutsrqponmlkjihgfedcba <<<"$*"
}

main() {
	local func="$1" input
	shift
	input="$(tr -cd '[:alnum:]' <<<"${*,,}")"
	$func "$input"
}
main "$@"
