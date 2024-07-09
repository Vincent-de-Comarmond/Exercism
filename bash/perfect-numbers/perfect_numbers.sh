#!/usr/bin/env bash
validate() {
	if test "$1" -lt 1; then
		echo "Classification is only possible for natural numbers." >/dev/stderr
		exit 1
	fi
}

aliquot_sum() {
	local -i i sum=0
	for ((i = 1; i * i <= $1; i++)); do
		if (($1 % i == 0)); then
			((sum += i))
			(((i != $1 / i) && (sum += $1 / i)))
		fi
	done
	((sum -= $1))
	echo "$sum"
}

main() {
	local a_sum result
	a_sum=$(aliquot_sum "$1")
	[ "$a_sum" -gt "$1" ] && result="abundant"
	[ "$a_sum" -lt "$1" ] && result="deficient"
	[ "$a_sum" -eq "$1" ] && result="perfect"
	echo "$result"
}

validate "$1"
main "$1"
