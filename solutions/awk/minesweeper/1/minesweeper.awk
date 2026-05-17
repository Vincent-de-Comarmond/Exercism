BEGIN {
	split("", board, FS)
}

{
	idx = 1
	split($0, row, "")
	for (val in row) {
		board[NR][idx] = row[val]
		idx++
	}
}

END {
	replace_all()
	for (i in board) {
		if (i > 1) {
			print ""
		}
		for (j in board[i]) {
			printf "%s", board[i][j]
		}
	}
}


function replace(_i, _j)
{
	count = 0
	if (board[_i][_j] == ".") {
		for (__i = _i - 1; __i <= _i + 1; __i++) {
			for (__j = _j - 1; __j <= _j + 1; __j++) {
				if (__i != 0 || __j != 0) {
					if (board[__i][__j] == "*") {
						count++
					}
				}
			}
		}
		board[_i][_j] = (count == 0 ? "." : count)
	}
}

function replace_all()
{
	for (i in board) {
		for (j in board[i]) {
			replace(i, j)
		}
	}
}
