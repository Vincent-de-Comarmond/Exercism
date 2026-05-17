BEGIN {
	numbers[" _ ,| |,|_|,   "] = 0
	numbers["   ,  |,  |,   "] = 1
	numbers[" _ , _|,|_ ,   "] = 2
	numbers[" _ , _|, _|,   "] = 3
	numbers["   ,|_|,  |,   "] = 4
	numbers[" _ ,|_ , _|,   "] = 5
	numbers[" _ ,|_ ,|_|,   "] = 6
	numbers[" _ ,  |,  |,   "] = 7
	numbers[" _ ,|_|,|_|,   "] = 8
	numbers[" _ ,|_|, _|,   "] = 9
}

{
	lines[NR] = $0
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
	for (m_row = 1; m_row <= NR; m_row += 4) {
		if (m_row > 1) {
			printf ","
		}
		make_chunks(chunks, lines[m_row], lines[m_row + 1], lines[m_row + 2], lines[m_row + 3])
		for (idx = 1; idx <= length(chunks); idx++) {
			printf (chunks[idx] in numbers) ? numbers[chunks[idx]] : "?"
		}
	}
}


function make_chunks(return_matrix, row1, row2, row3, row4, _i)
{
	split("", return_matrix, FS)
	for (_i = 1; _i <= length(row1); _i += 3) {
		return_matrix[length(return_matrix) + 1] = substr(row1, _i, 3) "," substr(row2, _i, 3) "," substr(row3, _i, 3) "," substr(row4, _i, 3)
	}
}
