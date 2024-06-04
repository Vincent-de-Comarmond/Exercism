BEGIN {
	split("ABCDEFGHIJKLMNOPQRSTUVWXYZ", letter_positions, "")
}

{
	input_letter = $1
}

END {
	for (idx in letter_positions) {
		if (letter_positions[idx] == input_letter) {
			break
		}
	}
	size = 2 * idx - 1	# Must always be odd
	centre = idx
	print size
	print centre
	for (line = 1; line <= size; line++) {
		if (line <= centre) {
			gap = 2 * line - 3
		} else {
			gap = size - 2 * line - 3
		}
		for (idx = 1; idx <= size; idx++) {
			char = (line < size / 2) ? letter_positions[line] : letter_positions[size - line]
			symbol = (idx == size - int(gap / 2) - 1) ? char : (idx == size + int(gap / 2)) ? char : " "
			printf symbol
		}
		print ""
	}
}

