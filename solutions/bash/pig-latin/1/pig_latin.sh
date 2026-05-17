#!/usr/bin/env bash
handle_word() {
	if [[ "$1" =~ ^(xr|yt|[aeiou]) ]]; then echo "$1"ay && return; fi
	if [[ "$1" =~ ^qu ]]; then echo "${1:2}quay" && return; fi
	if [[ "$1" =~ ^[^aeiou]y ]]; then echo "y${1#*y}${1%y*}ay" && return; fi
	handle_word "${1:1}${1:0:1}"
}

main() {
	local -a words
	for word in "$@"; do words+=($(handle_word "$word")); done
	echo "${words[@]}"
}

main "$@"
