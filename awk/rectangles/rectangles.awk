BEGIN {
	FS = ""
	idx = 0
}

{
	for (i = 1; i <= NF; i++) {
		if ($i != " ") {
			shapes[idx] = $i
		}
		idx++
	}
	rows = NR
	columns = NF
}

END {
	split("", rectangles, FS)
	for (i in shapes) {
		if (shapes[i] == "+") {
			resolve_rectangles(i, shapes, rectangles)
		}
	}
	total = 0
	for (unvalidated in rectangles) {
		total += validate_rectangle(shapes, unvalidated)
	}
	print total
}


function resolve_rectangles(loc, shape_stack, rectangle_stack, _row, _col, _i, _j, _k, _assoc_rows, _assoc_cols)
{
	_col = loc % columns
	_row = int(loc / columns)
	split("", _assoc_rows, FS)
	split("", _assoc_cols, FS)
	for (_i in shape_stack) {
		if (_i != loc && shape_stack[_i] == "+") {
			if (_i % columns == _col) {
				_assoc_cols[_i]++
			}
			if (int(_i / columns) == _row) {
				_assoc_rows[_i]++
			}
		}
	}
	for (_i in _assoc_rows) {
		for (_j in _assoc_cols) {
			# New loc = col of assoc row + row of assoc col
			_k = _i % columns + (_j - _j % columns)
			if (_i == _j || _i == _k || _j == _k || _i == loc || _j == loc || _k == loc) {
				continue
			}
			# Check that associated row and column line up
			if (shape_stack[_k] == "+") {
				rectangle_stack[sort(loc, _i, _j, _k)]++
			}
		}
	}
}

function sort(a, b, c, d, _tmp, _result, _i)
{
	split(a SUBSEP b SUBSEP c SUBSEP d, _tmp, SUBSEP)
	asort(_tmp)
	for (_i in _tmp) {
		_result = (_i == 1) ? _tmp[_i] : _result SUBSEP _tmp[_i]
	}
	return _result
}

function validate_rectangle(shape_stack, rectangle, _tmp, _i, _a, _b, _j, _k)
{
	split(rectangle, _tmp, SUBSEP)
	# Relationships
	# 1 and 2 are horizontal, 3 and 4 are horizontal
	# 1 and 3 are vertical, 2 and 4 are vertical
	
	# Handle horizontal
	for (_i = _tmp[1] % columns; _i <= _tmp[2] % columns; _i++) {
		_a = shape_stack[_i + int(_tmp[1] / columns) * columns]
		_b = shape_stack[_i + int(_tmp[3] / columns) * columns]
		if ((_a != "-" && _a != "+") || (_b != "-" && _b != "+")) {
			return 0
		}
	}
	# Handle vertical
	for (_i = int(_tmp[1] / columns); _i <= int(_tmp[4] / columns); _i++) {
		_a = shape_stack[_i * columns + _tmp[1] % columns]
		_b = shape_stack[_i * columns + _tmp[2] % columns]
		if ((_a != "|" && _a != "+") || (_b != "|" && _b != "+")) {
			return 0
		}
	}
	return 1
}
