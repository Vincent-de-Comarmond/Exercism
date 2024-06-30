#!/usr/bin/env bash
main() {
	local i j
	local -a primes
	local -A marked
	for ((i = 2; i <= "$1"; i++)); do
		if test -z "${marked[$i]}"; then
			primes+=("$i")
			for ((j = 1; j <= $1 / i; j++)); do
				marked[$((j * i))]=1
			done
		fi
	done
	echo "${primes[@]}"
}
main "$1"
