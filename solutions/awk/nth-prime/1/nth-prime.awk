# These variables are initialized on the command line (using '-v'):
# - n
BEGIN {
	primes[1] = 2
	primes[2] = 3
	find_primes_to_n(primes, n)
	print find_primes_to_n(primes, n)
	exit 0
}


function find_primes_to_n(prime_stack, n, _current, _i, _prime_p)
{
	if (length(prime_stack) >= n) {
		return prime_stack[n]
	}
	# We know there are no even primes
	if (_current == "") {
		_current = prime_stack[length(prime_stack)] + 2
	}
	_prime_p = 1
	for (_i in prime_stack) {
		if (_current % prime_stack[_i] == 0) {
			_prime_p = 0
			break
		}
	}
	if (_prime_p) {
		prime_stack[length(prime_stack) + 1] = _current
	}
	return find_primes_to_n(prime_stack, n, _current + 2)
}
