#!/usr/bin/env bash
declare -a primes=(2 3)
declare -i idx=0

generate_prime() {
	local -i current val prime=0
	((current = primes[-1] + 2))
	while ((prime == 0)); do
		prime=1
		for val in "${primes[@]}"; do
			((current % val == 0)) && prime=0 && break
		done
		((prime == 1)) && primes+=("$current") || ((current += 2))
	done
}

next_prime() {
	if [ "$idx" -lt "${#primes[@]}" ]; then
		echo "${primes[$idx]}"
		((idx++))
		return
	fi
	generate_prime
	next_prime
}

main() {
	local -i remaining="$1" current
	local -a factors
	next_prime >3
	read current <3
	while ((remaining != 1)); do
		if ((remaining % current == 0)); then
			((remaining /= current))
			factors+=("$current")
		else
			next_prime >3
			read current <3
		fi
	done
	echo "${factors[@]}"
}
main "$1"
