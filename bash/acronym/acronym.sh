#!/usr/bin/env bash
main() {
	local words="${1//[^A-Za-z\']/ }"
	local acronym=""
	for word in $words; do
		acronym=$acronym"${word:0:1}"
	done
	echo "${acronym^^}"
}

main "$@"
