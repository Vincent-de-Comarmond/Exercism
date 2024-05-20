BEGIN {
	primes[1] = 2
	primes[2] = 3
}

{
	split("", factors, FS)
	idx = 1	# Start with first prime
	factor = $1
	while (factor > 1) {
		prime = primes[idx]
		while (factor % prime == 0) {
			factor = factor / prime
			factors[length(factors) + 1] = prime
		}
		idx++
		if (idx > length(primes)) {
			find_more_primes(primes, 100)
		}
	}
	for (idx in factors) {
		printf (idx > 1) ? " %s" : "%s", factors[idx]
	}
}


function find_more_primes(prime_numbers, how_many_more)
{
	seed = primes[length(prime_numbers)]
	while (how_many_more > 0) {
		seed += 2
		is_prime = 1
		for (_idx in prime_numbers) {
			prime = prime_numbers[_idx]
			if (seed % prime == 0) {
				is_prime = 0
				break
			}
		}
		if (is_prime) {
			primes[length(prime_numbers) + 1] = seed
			how_many_more--
		}
	}
}
