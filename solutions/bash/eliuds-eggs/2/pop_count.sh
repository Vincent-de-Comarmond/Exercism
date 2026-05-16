#!/usr/bin/env bash
main() {
	# Octal and binary are friends
	local -a oct_2_bin=(0 1 1 2 1 2 2 3)
	local -i octal i eggs=0
	printf -v octal "%o\n" "$1"
	for ((i = 0; i < ${#octal}; i++)); do
		((eggs += oct_2_bin[${octal:i:1}]))
	done
	echo "$eggs"
}
main "$1"
