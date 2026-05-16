#!/usr/bin/env bash
main() {
	if [ "$1" -le 0 ]; then echo "invalid input" >/dev/stderr && exit 1; fi

	local -a primes=(2 3)
	local -i isprime=1 test_p=3
	if (($1 <= 2)); then echo "${primes[$1 - 1]}" && return; fi
	while ((${#primes[@]} < $1)); do
		isprime=1
		((test_p += 2))
		for ((i = 0; primes[i] * primes[i] <= test_p; i++)); do
			if ((test_p % primes[i] == 0)); then
				isprime=0
				break
			fi
		done
		if ((isprime == 1)); then primes+=("$test_p"); fi
	done
	echo "${primes[-1]}"
}
main "$1"
