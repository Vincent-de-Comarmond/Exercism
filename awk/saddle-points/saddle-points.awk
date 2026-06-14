BEGIN {
	split("", max_ew, FS)
	split("", min_ns, FS)
}

{
	_max_ew = -1
	for (i = 1; i <= NF; i++) {
		_max_ew = _max_ew < $i ? $i : _max_ew
		if (NR == 1) {
			min_ns[i] = $i
		} else {
			min_ns[i] = $i < min_ns[i] ? $i : min_ns[i]
		}
	}
	for (i = 1; i <= NF; i++) {
		if ($i == _max_ew) {
			max_ew[NR][i] = $i
		}
	}
}

END {
	for (row in max_ew) {
		for (col in max_ew[row]) {
			if (max_ew[row][col] == min_ns[col]) {
				print row, col
			}
		}
	}
}

