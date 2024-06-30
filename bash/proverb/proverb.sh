#!/usr/bin/env bash
main() {
	local arg prev
	for arg in "$@"; do
		[[ "$arg" != "$1" ]] && echo "For want of a $prev the $arg was lost."
		prev=$arg
	done
	[ "$#" -gt 0 ] && echo "And all for the want of a $1." || exit 0
}

main "$@"
