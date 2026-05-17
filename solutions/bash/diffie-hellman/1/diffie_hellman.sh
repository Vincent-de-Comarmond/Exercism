#!/usr/bin/env bash
_generatePrimes() {
	local -i i j stop isprime=0
	local -a primes=(2)
	stop="$(bc <<<"sqrt($1)")"
	for ((i = 3; i <= $stop; i += 1)); do
		isprime=1
		for j in "${primes[@]}"; do
			if ((i % j == 0)); then isprime=0 && break; fi
		done
		if ((isprime == 1)); then primes+=("$i"); fi
	done
	echo "${primes[@]}"
}

privateKey() {
	local -a primes
	read -r -a primes <<<"$(_generatePrimes "$1")"
	echo "${primes[$RANDOM % ${#primes[@]}]}"
}

main() {
	if [ "$1" == "privateKey" ]; then
		privateKey "$2"
	elif [ "$1" == "publicKey" ]; then
		echo $((($3 ** $4) % $2))
	elif [ "$1" == "secret" ]; then
		echo $((($3 ** $4) % $2))
	fi
}

main "$@"
