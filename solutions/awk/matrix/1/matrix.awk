
@namespace "matrix"


function column(matrix_var, column_num, _i, _tmp)
{
	for (_i = 1; _i <= length(matrix_var); _i++) {
		_tmp = _tmp " " matrix_var[_i][column_num]
	}
	return substr(_tmp, 2)
}

function read(filename, matrix_var, _row, _col, _i, _j)
{
	# clear variable
	split("", matrix_var, FS)
	while ((getline _row < filename) > 0) {
		_i = length(matrix_var) + 1
		split(_row, _col, FS)
		for (_j = 1; _j <= length(_col); _j++) {
			matrix_var[_i][_j] = _col[_j]
		}
	}
}

function row(matrix_var, row_num, _j, _tmp)
{
	for (_j = 1; _j <= length(matrix_var[row_num]); _j++) {
		_tmp = _tmp " " matrix_var[row_num][_j]
	}
	return substr(_tmp, 2)
}
