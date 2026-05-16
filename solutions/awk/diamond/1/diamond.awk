BEGIN {
	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

{
	input_letter = $1
}

END {
	idx = index(alphabet, input_letter)
	size = 2 * idx - 1	# Must always be odd
	for (row = 1; row <= size; row++) {
		for (col = 1; col <= size; col++) {
			if (row - col == idx - 1 || row - col == -idx + 1 || row + col == idx + 1 || row + col == size + idx) {
				char = (row <= idx) ? substr(alphabet, row, 1) : substr(alphabet, size - row + 1, 1)
			} else {
				char = " "
			}
			printf char
		}
		print ""
	}
}

