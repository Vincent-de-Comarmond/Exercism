BEGIN {
	split("", triplets, FS)
	solve(sum, triplets)
	for (triple in triplets) {
		print triple
	}
	exit 0
}


function solve(sum, triplets)
{
	for (m = 2; m <= int(sqrt(sum / 2)); m++) {
		# sum = 2m^2 + 2 m n
		# m^2 < m^2 + mn = sum/2 => m < sqrt(sum/2)
		for (n = 1; n < m; n++) {
			a = m ^ 2 - n ^ 2
			b = 2 * m * n
			c = m ^ 2 + n ^ 2
			if (sum % (a + b + c) == 0) {
				k = sum / (a + b + c)
				tmp = a < b ? (k * a) "," (k * b) : (k * b) "," (k * a)	# c is always biggest
				tmp = tmp "," (k * c)
				triplets[tmp] = 1
				continue
			}
		}
	}
}
