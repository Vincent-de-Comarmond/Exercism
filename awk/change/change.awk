NR == 1 {
	for (i = 1; i <= NF; i++) {
		denominations[$i]++
	}
}

NR == 2 {
	total_change = $1
}

END {
	solution = solve(total_change, denominations, solutions)
	solution = sort_str(solution)
	gsub(SUBSEP, FS, solution)
	print solution
}


function solve(change, denominations, solution_array, _recurse, _coins, _coin)
{
	solution_array[-1] = change
	do {
		_recurse = 0
		for (_coins in solution_array) {
			# print _coins, solution_array[_coins]
			if (solution_array[_coins] <= 0) {
				continue
			}
			for (_coin in denominations) {
				if (_coin < solution_array[_coins]) {
					_recurse = 1
					solution_array[(_coins == -1) ? _coin : _coins SUBSEP _coin] = solution_array[_coins] - _coin
				} else if (_coin == solution_array[_coins]) {
					return (_coins == -1) ? _coin : _coins SUBSEP _coin
				}
			}
			delete solution_array[_coins]
		}
	} while (_recurse)
}

function sort_str(input_str, _tmp, _i, _val)
{
	split(input_str, _tmp, SUBSEP)
	asort(_tmp)
	for (_i in _tmp) {
		_val = (_i == 1) ? _tmp[_i] : _val SUBSEP _tmp[_i]
	}
	return _val
}
