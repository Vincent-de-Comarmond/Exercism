BEGIN {
	PROCINFO["sorted_in"] = "@ind_num_desc"
}

NR == 1 {
	min_coin = 1000000000
	for (i = 1; i <= NF; i++) {
		min_coin = ($i < min_coin) ? $i : min_coin
		denominations[$i]++
	}
}

NR == 2 {
	total_change = $1
}

END {
	if (total_change == 0) {
		exit 0
	}
	if (total_change < min_coin) {
		if (total_change < 0) {
			print("target can't be negative") >> "/dev/stderr"
		} else {
			print("can't make target with given coins") >> "/dev/stderr"
		}
		exit 1
	}
	solution = solve_bfs(total_change, denominations, solutions)
	if (solution == "") {
		print("can't make target with given coins") >> "/dev/stderr"
		exit 1
	}
	solution = sort_str(solution)
	gsub(SUBSEP, FS, solution)
	print solution
}


function solve_bfs(change, denominations, solution_array, _recurse, _coins, _coin)
{
	solution_array[-1] = change
	do {
		_recurse = 0
		for (_coins in solution_array) {
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
	asort(_tmp, _tmp, "@val_num_asc")
	for (_i = 1; _i <= length(_tmp); _i++) {
		_val = (length(_val) == 0) ? _tmp[_i] : _val SUBSEP _tmp[_i]
	}
	return _val
}
