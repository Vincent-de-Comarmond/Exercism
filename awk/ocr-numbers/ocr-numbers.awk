BEGIN {
	split("", numbers, FS)
	numbers[" _ ,| |,|_|,   "] = 0
	numbers["   ,  |,  |,   "] = 1
	numbers[" _ , _|,|_ ,   "] = 2
	# split(" _ ,| |,|_|,   ", numbers[0], ",")
	# split("   , | , | ,   ", numbers[1], ",")
	# split(" _ , _|,|_ ,   ", numbers[2], ",")
	split("", lines, FS)
}

{
	lines[length(lines) + 1] = $0
}

END {
	if (NR % 4 != 0) {
		print("Number of input lines is not a multiple of four") >> "/dev/stderr"
		exit 1
	}
	if (length($0) % 3 != 0) {
		print("Number of input columns is not a multiple of three") >> "/dev/stderr"
		exit 1
	}
	make_chunks(chunks, lines[1], lines[2], lines[3], lines[4])
	for (idx = 1; idx <= length(chunks); idx++) {
		printf (chunks[idx] in numbers) ? numbers[chunks[idx]] : "?"
		# printf "%s: %s\n", chunks[idx], (chunks[idx] in numbers) ? numbers[chunks[idx]] : "?"
	}
}


function make_chunks(return_matrix, row1, row2, row3, row4, _i)
{
	split("", return_matrix, FS)
	for (_i = 1; _i <= length(row1); _i += 3) {
		return_matrix[length(return_matrix) + 1] = substr(row1, _i, 3) "," substr(row2, _i, 3) "," substr(row3, _i, 3) "," substr(row4, _i, 3)
	}
}
