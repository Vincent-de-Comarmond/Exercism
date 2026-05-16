BEGIN {
	split("", tmp, FS)
	split("", hand, FS)
	split("", suite, FS)
	split("", winner_hand, FS)
	split("", winner_suite, FS)
	split("", winners, FS)
	winner_score = -9999
	score = 0
}

{
	prescore_hand($0, hand, suite)
	score = score_hand(hand, suite)
	if (winner_score == score) {
		breaker = break_tie(score, winner_hand, hand)
		if (0 < breaker) {
			next
		}
		if (breaker == 0) {
			winners[length(winners) + 1] = $0
			next
		}
		if (breaker < 0) {
			copy_array(hand, winner_hand)
			copy_array(suite, winner_suite)
			split("", winners, FS)
			winners[1] = $0
			next
		}
	}
	if (winner_score < score) {
		winner_score = score
		copy_array(hand, winner_hand)
		copy_array(suite, winner_suite)
		split("", winners, FS)
		winners[1] = $0
	}
}

END {
	for (_i in winners) {
		print winners[_i]
	}
}

function array_max(input_array, _i, _max)
{
	_max = -999999999
	for (_i in input_array) {
		if (_max < input_array[_i]) {
			_max = input_array[_i]
		}
	}
	return _max
}

function break_tie(score, vals1, vals2, _i, _counts1, _inv1, _counts2, _inv2)
{
	for (_i = 1; _i <= 5; _i++) {
		_counts1[vals1[_i]]++
		_counts2[vals2[_i]]++
	}
	switch (score + 0) {
	case 11:
		return 0
	case 10:
		_i = vals1[1] - vals2[1]
		if (_i == 0) {
			return 0
		}
		if (vals1[1] == 14) {
			return -1
		}
		if (vals2[1] == 14) {
			return 1
		}
		return _i
	case 9:
		_i = extract_value_with_counts(_counts1, 4) - extract_value_with_counts(_counts2, 4)
		if (_i == 0) {
			return (extract_value_with_counts(_counts1, 1) - extract_value_with_counts(_counts2, 1))
		}
		return _i
	case 8:
		_i = extract_value_with_counts(_counts1, 3) - extract_value_with_counts(_counts2, 3)
		if (_i == 0) {
			return (extract_value_with_counts(_counts1, 2) - extract_value_with_counts(_counts2, 2))
		}
		return _i
	case 7:
		return direct_search(vals1, vals2)
	case 6:
		_i = vals1[1] - vals2[1]
		if (_i == 0) {
			return 0
		}
		if (vals1[1] == 14) {
			return -1
		}
		if (vals2[1] == 14) {
			return 1
		}
		return _i
	case 5:
		_i = extract_value_with_counts(_counts1, 3) - extract_value_with_counts(_counts2, 3)
		if (_i != 0) {
			return _i
		}
		return direct_search(vals1, vals2)
	case 4:
		# Highest pair value can always be found at 2
		_i = vals1[2] - vals2[2]
		if (_i != 0) {
			return _i
		}
		# Second highest pair value can always be found at 4
		_i = vals1[4] - vals2[4]
		if (_i != 0) {
			return _i
		}
		return (extract_value_with_counts(_counts1, 1) - extract_value_with_counts(_counts2, 1))
	case 3:
		_i = extract_value_with_counts(_counts1, 2) - extract_value_with_counts(_counts2, 2)
		if (_i != 0) {
			return _i
		}
		return direct_search(vals1, vals2)
	}
	return direct_search(vals1, vals2)
}

function copy_array(src, dst, _i)
{
	dst[0] = 0
	split("", dst, FS)
	for (_i in src) {
		dst[_i] = src[_i]
	}
}

function direct_search(arr1, arr2, _j, _diff)
{
	for (_j = 1; _j <= 5; _j++) {
		_diff = arr1[_j] - arr2[_j]
		if (_diff != 0) {
			return _diff
		}
	}
	return 0
}

function extract_value_with_counts(counts_arr, count_sought, _i)
{
	for (_i in counts_arr) {
		if (counts_arr[_i] == count_sought) {
			return _i
		}
	}
}

function prescore_hand(input_str, sorted_vals, sorted_suites, _lcl_array, _lcl_vals, _lcl_suites, _i, _tmp_idx)
{
	_lcl_array[1] = -1
	_lcl_vals[1] = -1
	_lcl_suites[1] = ""
	split(input_str, _lcl_array, FS)
	for (_i = 1; _i <= 5; _i++) {
		_lcl_vals[_i] = tonumeric(substr(_lcl_array[_i], 1, length(_lcl_array[_i]) - 1))
		_lcl_suites[_i] = substr(_lcl_array[_i], length(_lcl_array[_i]))
	}
	asorti(_lcl_vals, _tmp_idx, "@val_num_desc")
	for (_i = 1; _i <= 5; _i++) {
		sorted_vals[_i] = _lcl_vals[_tmp_idx[_i]]
		sorted_suites[_i] = _lcl_suites[_tmp_idx[_i]]
	}
}

function print_array(input_arr, _i)
{
	printf "[ "
	for (_i in input_arr) {
		printf "%s ", input_arr[_i]
	}
	print "]"
}

function score_hand(vals, suites, _same_suite, _is_straight, _counts, _i, _count, _num_different)
{
	_same_suite = (suites[1] == suites[2]) && (suites[2] == suites[3]) && (suites[3] == suites[4]) && (suites[4] == suites[5])
	_is_straight = (vals[4] == vals[5] + 1) && (vals[2] == vals[3] + 1) && (vals[3] == vals[4] + 1)
	_is_stright = _is_straight && ((vals[1] - vals[2] == 1) || ((vals[1] - vals[2] == 9)))
	# Royal Flush
	if (_same_suite && _is_straight && vals[2] == 13) {
		return 11
	}
	# Stright Flush
	if (_same_suite && _is_straight) {
		return 10
	}
	for (_i = 1; _i <= 5; _i++) {
		_counts[vals[_i]]++
	}
	_num_different = length(_counts)
	if (_num_different == 2) {
		for (_val in _counts) {
			# 4 of a kind
			if ((_counts[_val] == 1) || (_counts[_val] == 4)) {
				return 9
			}
			# Full house
			if ((_counts[_val] == 2) || (_counts[_val] == 3)) {
				return 8
			}
		}
	}
	# Flush
	if (_same_suite) {
		return 7
	}
	# Straight
	if (_is_straight) {
		return 6
	}
	if (_num_different == 3) {
		# 3 of  a kind
		for (_val in _counts) {
			if (_counts[_val] == 3) {
				return 5
			}
			# 2 pair
			if (_counts[_val] == 2) {
				return 4
			}
		}
	}
	# One pair
	if (_num_different == 4) {
		return 3
	}
	# High card
	return (array_max(vals) + 0) / 15
}

function tonumeric(card)
{
	if (card == "A") {
		return 14
	}
	if (card == "K") {
		return 13
	}
	if (card == "Q") {
		return 12
	}
	if (card == "J") {
		return 11
	}
	return (card + 0)
}
