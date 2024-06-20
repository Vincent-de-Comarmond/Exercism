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


function array_idx_max(input_array, _max, _key)
{
	for (_key in input_array) {
		_max = (length(_max) == 0) ? _key : (_key > _max) ? _key : _max
	}
	return _max
}

function reduce_selection(target_amount, denomination_array, result_array, _coin, _keep)
{
	split("", result_array, FS)
	for (_coin in denomination_array) {
		if (_coin > target_amount) {
			continue
		}
		_keep = 1
		# Skip smaller denominations if we can get to the target with bigger ones
		for (_bigger in result_array) {
			if (target_amount - _bigger > array_idx_max(result_array) && _bigger % _coin == 0) {
				_keep = 0
				break
			}
		}
		if (_keep) {
			result_array[_coin]++
		}
	}
}

function solve_bfs(change, denominations, solution_array, _recurse, _coins, _coin, _reduced)
{
	solution_array[-1] = change
	do {
		_recurse = 0
		for (_coins in solution_array) {
			if (solution_array[_coins] <= 0) {
				continue
			}
			reduce_selection(solution_array[_coins], denominations, _reduced)
			for (_coin in _reduced) {
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
