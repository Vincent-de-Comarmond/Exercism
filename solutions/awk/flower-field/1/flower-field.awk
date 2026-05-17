BEGIN {
	split("", grid, FS)
}

{
	split($0, grid[NR], "")
}

END {
	split("", out, FS)
	for (i = 1; i <= length(grid); i++) {
		for (j = 1; j <= length(grid[i]); j++) {
			count = 0
			if (grid[i][j] == "*") {
				out[i][j] = grid[i][j]
				continue
			}
			for (k = 0; k < 9; k++) {
				if (k != 4) {
					ii = i + int(k / 3) - 1
					jj = j + (k % 3) - 1
					if ((ii in grid) && (jj in grid[ii]) && (grid[ii][jj] == "*")) {
						count++
					}
				}
			}
			out[i][j] = count == 0 ? "." : count
		}
	}
	for (i in out) {
		for (j in out[i]) {
			printf "%s", out[i][j]
		}
		print ""
	}
}
