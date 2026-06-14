# These variables are initialized on the command line (using '-v'):
# - sum
BEGIN {
	split("", triplets, FS)
	solve(sum, triplets)
	for (i = 1; i <= length(triplets); i++) {
		print triplets[i]
	}
	exit 0
}


function solve(sum, triplets, a, b, c)
{
	for (a = 1; a <= sum / 3; a++) {
		for (b = a + 1; b <= sum - 2 * a - 1; b++) {
			c = sum - a - b
			if (c ^ 2 == a ^ 2 + b ^ 2) {
				triplets[length(triplets) + 1] = a "," b "," c
				continue
			}
		}
	}
}
