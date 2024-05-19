# These variables are initialized on the command line (using '-v'):
# - num
BEGIN {
	total = 0
	for (i = 1; i <= length(num); i++) {
		total += substr(num, i, 1) ^ length(num)
	}
	print (total == num) ? "true" : "false"
}

