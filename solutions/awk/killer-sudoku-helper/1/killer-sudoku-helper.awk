{
	split("", not_allowed, FS)
	for (i = 3; i <= NF; i++) {
		not_allowed[$i] = 1
	}
	solve($1, $2, 1, "", not_allowed)
}


function solve(total, num_digits, start_idx, accumulator, disallow, _idx, _alpha, _beta)
{
	if ((num_digits + 0 == 0) && (total == 0)) {
		print accumulator
	}
	if ((num_digits + 0 <= 0) || (total <= 0)) {
		return
	}
	for (_idx = start_idx; _idx <= 9; _idx++) {
		_next = accumulator == "" ? _idx : accumulator " " _idx
		if (_idx in disallow) {
			_beta = solve(total, num_digits, _idx + 1, accumulator, disallow)
			return _beta
		} else {
			_alpha = solve(total - _idx, num_digits - 1, _idx + 1, accumulator == "" ? _idx : accumulator " " _idx, disallow)
			_beta = solve(total, num_digits, _idx + 1, accumulator, disallow)
			return (_alpha _beta)
		}
	}
	return
}
