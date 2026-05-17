{
	split($0, a, ",")
	total = 0
	if (a[1] == "difference") {
		for (i = 1; i <= a[2]; i++) {
			for (j = 1; j < i; j++) {
				total += 2 * i * j
			}
		}
	} else if (a[1] == "square_of_sum") {
		for (i = 1; i <= a[2]; i++) {
			subtotal += i
		}
		total = subtotal * subtotal
	} else {
		for (i = 1; i <= a[2]; i++) {
			total += i * i
		}
	}
}

END {
	print total
}

