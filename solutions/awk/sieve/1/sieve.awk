BEGIN {
	PROCINFO["sorted_in"] = "@ind_num_asc"
}

/^[0-9]+$/ {
	if ($1 > 1) {
		make_stack(stack, $1)
		primes[1] = 2
		sieve_eratosthenes(stack, primes, $1)
		output = ""
		for (i in primes) {
			output = output "," primes[i]
		}
		print substr(output, 2)
	}
}


function make_stack(stack, limit, _i)
{
	split("", stack, FS)
	for (_i = 2; _i <= limit; _i++) {
		stack[_i]++
	}
}

function sieve_eratosthenes(stack, primes, limit, _idx)
{
	if (length(stack) == 0) {
		return
	}
	_idx = 1
	while (primes[length(primes)] * _idx <= limit) {
		# print length(primes), primes[length(primes)] * _idx
		if (primes[length(primes)] * _idx in stack) {
			delete stack[primes[length(primes)] * _idx]
		}
		_idx++
	}
	for (_idx in stack) {
		primes[length(primes) + 1] = _idx
		break
	}
	return sieve_eratosthenes(stack, primes, limit)
}
