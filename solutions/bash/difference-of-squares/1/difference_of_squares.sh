#!/usr/bin/env bash
square_of_sum() {
	local sn
	((sn = $1 * ($1 + 1) / 2))
	((sn = sn ** 2))
	echo "$sn"
}

sum_of_squares() {
	local sn
	((sn = $1 * ($1 + 1) * (2 * $1 + 1) / 6))
	echo "$sn"
}

difference() {
	local sqsum sumsq res
	sqsum=$(square_of_sum "$1")
	sumsq=$(sum_of_squares "$1")
	((res = sqsum - sumsq))
	echo "$res"
}

main() {
	"$1" "$2"
}
main "$@"
