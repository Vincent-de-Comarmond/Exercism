BEGIN {
	price[1] = 800
	for (i = 2; i <= 5; i++) {
		discount = (i == 2) ? 0.95 : (i == 3) ? 0.9 : (i == 4) ? 0.85 : 0.75
		price[i] = price[1] * i * discount
	}
}

{
	books[$i]++
}

END {
	total_books = NR
	for (i = 1; i <= (leftover < 5) ? leftover : 5; i++) {
		groupsize = i
		if (groupsize == 1) {
		} else {
		}
	}
}

