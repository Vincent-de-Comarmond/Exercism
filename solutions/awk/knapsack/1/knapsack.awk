BEGIN {
	FS = ":"
	split("", store, FS)
}

/limit:[0-9]+/ {
	limit = $2
	next
}

/weight:[0-9]+,value:[0-9]+/ {
	split($2, _tmp, ",")
	# weight
	items[NR - 1][1] = _tmp[1]
	# value
	items[NR - 1][2] = $3
	next
}

END {
	max = 0
	all_choices(choice_array, length(items))
	for (_choice in choice_array) {
		split(_choice, _tmp, SUBSEP)
		total_weight = 0
		total_value = 0
		for (_idx in _tmp) {
			total_weight += items[_tmp[_idx]][1]
			total_value += items[_tmp[_idx]][2]
			if (total_weight > limit) {
				total_value = 0
				break
			}
		}
		max = (total_value > max) ? total_value : max
	}
	print max
}


function all_choices(choice_array, n, _j, _k)
{
	split("", choice_array, FS)
	for (_j = n; _j >= 1; _j--) {
		choose(choices, n, _j)
		for (_k in choices) {
			choice_array[_k]++
		}
	}
}

function choose(choice_array, n, r, _i, _tmp)
{
	split("", choice_array, FS)
	if (length(choice_array) == 0) {
		for (_i = 1; _i <= n; _i++) {
			choice_array[_i]
		}
	}
	r--
	while (r > 0) {
		for (_choice in choice_array) {
			multindex_2_keys(_tmp, _choice)
			for (_i = 1; _i <= n; _i++) {
				if (! (_i in _tmp)) {
					choice_array[sort_multindex(_choice SUBSEP _i)]++
				}
			}
			delete choice_array[_choice]
		}
		if (length(choice_array) == 0) {
			for (_i = 1; _i <= n; _i++) {
				choice_array[_i]
			}
		}
		r--
	}
}

function multindex_2_keys(result, multindex, _tmp, _i)
{
	split("", result, FS)
	split(multindex, _tmp, SUBSEP)
	for (_i in _tmp) {
		result[_tmp[_i]]++
	}
}

function sort_multindex(multindex, _tmp, _i, _val)
{
	split(multindex, _tmp, SUBSEP)
	asort(_tmp)
	_val = ""
	for (_i in _tmp) {
		_val = (length(_val) == 0) ? _tmp[_i] : _val SUBSEP _tmp[_i]
	}
	return _val
}
