# These variables are initialized on the command line (using '-v'):
# - size
BEGIN {
	if (size < 2) {
		print (size == 0) ? "" : 1
		exit 0
	}
	for (i = 1; i <= size; i++) {
		for (j = 1; j <= size; j++) {
			matrix[i][j] = 0
		}
	}
	walk(matrix, 1, 1, 0, 0)
	for (i = 1; i <= length(matrix); i++) {
		for (j = 1; j <= length(matrix[i]); j++) {
			val = matrix[i][j]
			printf (j == 1) ? val : (j == length(matrix[i])) ? " " val "\n" : " " val
		}
	}
}


function walk(input_matrix, step, row, col, dir, bail, _j, _i)
{
	dir = dir % 4
	_i = (dir == 1) ? row + 1 : (dir == 3) ? row - 1 : row
	_j = (dir == 0) ? col + 1 : (dir == 2) ? col - 1 : col
	if (_i in input_matrix && _j in input_matrix[_i]) {
		if (input_matrix[_i][_j] == 0) {
			input_matrix[_i][_j] = step
			return walk(input_matrix, step + 1, _i, _j, dir, 0)
		}
		if (bail) {
			return
		}
	}
	return walk(input_matrix, step, row, col, dir + 1, 1)
}
