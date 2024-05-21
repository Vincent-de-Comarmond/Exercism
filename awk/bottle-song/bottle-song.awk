# These variables are initialized on the command line (using '-v'):
# - startBottles
# - takeDown
BEGIN {
	numbers[10] = "Ten"
	numbers[9] = "Nine"
	numbers[8] = "Eight"
	numbers[7] = "Seven"
	numbers[6] = "Six"
	numbers[5] = "Five"
	numbers[4] = "Four"
	numbers[3] = "Three"
	numbers[2] = "Two"
	numbers[1] = "One"
	numbers[0] = "No"
	for (i = startBottles; i >= startBottles - takeDown + 1; i--) {
		sing_pl_1 = (i >= 2) ? "bottles" : "bottle"
		sing_pl_2 = (i - 1 == 1) ? "bottle" : "bottles"
		number = numbers[i]
		number_dec = tolower(numbers[i - 1])
		line_1 = sprintf("%s green %s hanging on the wall,", number, sing_pl_1)
		line_2 = "And if one green bottle should accidentally fall,"
		line_3 = sprintf("There'll be %s green %s hanging on the wall.", number_dec, sing_pl_2)
		print line_1
		print line_1
		print line_2
		print line_3
		print ""
	}
}

