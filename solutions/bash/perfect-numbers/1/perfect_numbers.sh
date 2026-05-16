#!/usr/bin/env bash
validate() {
	if test "$1" -lt 1; then
		echo "Classification is only possible for natural numbers." >/dev/stderr
		exit 1
	fi
}

aliquot_sum() {
	local -i i sum=0 limit=$(bc <<<"sqrt($1)")
	for ((i = 1; i <= limit; i++)); do
		if (($1 % i == 0)); then
			((sum += i))
			((reciprocal = $1 / i))
			((sum += (reciprocal != i) ? reciprocal : 0))
		fi

	done
	((sum -= $1))
	echo "$sum"
}

main() {
	local -i a_sum diff
	a_sum=$(aliquot_sum "$1")
	((diff = $1 - a_sum))
	case "$diff" in
	0) echo "perfect" ;;
	-[0-9]*) echo "abundant" ;;
	*) echo "deficient" ;;
	esac
}

validate "$1"
main "$1"
