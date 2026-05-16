# These variables are initialized on the command line (using '-v'):
# - num
BEGIN {
	print_def = 1
	if ((num % 3) == 0) {
		print_def = 0
		printf "Pling"
	}
	if ((num % 5) == 0) {
		print_def = 0
		printf "Plang"
	}
	if ((num % 7) == 0) {
		print_def = 0
		printf "Plong"
	}
	if (print_def) {
		printf "%s\n", num
	}
}

