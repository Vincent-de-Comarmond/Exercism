#!/usr/bin/env bash

scale() {

	if [[ ! "$1" =~ \. ]]; then
		echo 0
		return
	fi
	local first
	first="${1##*.}"
	echo "${#first}"
}

toint() {
	if [[ ! "$1" =~ \. ]]; then
		[ "$2" -gt 0 ] && printf "%d%0$2d\n" "$1" || echo "$1"
		return
	fi
	local head tail zeros addzeros num
	tail="${1##*.}"
	head="${1%%.*}"
	zeros="${#tail}"
	num="$head$tail"
	num="${num#0}"
	((addzeros = $2 - zeros))
	[ "$addzeros" -gt 0 ] && printf "%d%0""$addzeros""d\n" "$num" 0 || echo "$num"
}

sum_sq() {
	echo $(($1 * $1 + $2 * $2))
}

main() {
	[ "$#" -ne 2 ] && echo "Incorrect number of inputs" >/dev/stderr && exit 1

	# validation and stuff
	local x y
	x="${1#-}"
	y="${2#-}"
	[[ ! "$x" =~ [0-9\.]+ ]] && echo "Non numeric input type" >/dev/stderr && exit 1
	[[ ! "$y" =~ [0-9\.]+ ]] && echo "Non numeric input type" >/dev/stderr && exit 1

	# Let's try do everything in pure bash
	local scale1 scale2 norm outer middle inner
	scale1=$(scale "$x")
	scale2=$(scale "$y")
	[ "$scale1" -ge "$scale2" ] && norm="$scale1" || norm="$scale2"

	# Convert numbers and calculate dist
	local num1 num2 dist_sq
	num1=$(toint "$x" "$norm")
	num2=$(toint "$y" "$norm")
	dist_sq=$(sum_sq "$num1" "$num2")

	# now it should be simple
	declare -a radii
	local outer middle inner rad_sq
	((outer = 100 * (10 ** norm) * (10 ** norm)))
	((middle = 25 * (10 ** norm) * (10 ** norm)))
	((inner = 1 * (10 ** norm) * (10 ** norm)))
	# echo $inner $middle $outer
	radii["$inner"]=10
	radii["$middle"]=5
	radii["$outer"]=1
	for rad_sq in "$inner" "$middle" "$outer"; do
		if [ "$dist_sq" -le "$rad_sq" ]; then
			echo "${radii[$rad_sq]}"
			return
		fi
	done
	echo 0

}
main "$1" "$2"
