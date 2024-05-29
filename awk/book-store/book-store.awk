BEGIN {
	price[1] = 800
	for (i = 2; i <= 5; i++) {
		discount = (i == 2) ? 0.95 : (i == 3) ? 0.9 : (i == 4) ? 0.85 : 0.75
		price[i] = price[1] * i * discount
	}
	split("r o y g b", book_color, FS)
}

{
	books[book_color[$1]]++
}

END {
	split("", choices, FS)
	choose(5, 1)
	for (key in choices) {
		counts++
		print key, choices[key]
	}
	print counts
}


function choose(n, r)
{
	# COMPUTE CHOICES (WITH REPETITION) HERE
	if (length(choices) == 0) {
		for (i = 1; i <= n; i++) {
			choices[i] = r - 1
		}
	}
	recurse = 0
	for (chosen in choices) {
		choices_remaining = choices[chosen]
		if (choices_remaining > 0) {
			recurse = 1
		}
		for (i = 1; i <= n; i++) {
			choices[chosen, i] = choices_remaining - 1
			delete choices[chosen]
		}
	}
	if (recurse == 1) {
		return choose(n, r)
	} else {
		# DO DEDUPLICATION HERE
		for (complex_key in choices) {
			split(complex_key, _tmp, SUBSEP)
			split("", __tmp, FS)
			asort(_tmp)
			# Deduplicating by setting of key of another a-array
			for (idx in _tmp) {
				__tmp[_tmp[idx]]++
			}
			newkey = 0
			keylength = 0
			for (idx in __tmp) {
				keylength++
				newkey = (newkey == 0) ? idx : newkey SUBSEP idx
			}
			value = choices[complex_key]
			delete choices[complex_key]
			if (keylength == r) {
				choices[newkey] = value
			}
		}
	}
}
