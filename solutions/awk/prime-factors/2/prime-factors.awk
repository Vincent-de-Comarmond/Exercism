{
	first = 1
	prime_factor = 2
	quotient = $1
	while (quotient > 1) {
		if (quotient % prime_factor == 0) {
			quotient = quotient / prime_factor
			printf (first) ? "%s" : " %s", prime_factor
			first = 0
			continue	# Don't increment
		}
		prime_factor = (prime_factor == 2) ? 3 : prime_factor + 2
	}
}

