BEGIN {
	price[1] = 800
	for (i = 2; i <= 5; i++) {
		discount = (i == 2) ? 0.95 : (i == 3) ? 0.9 : (i == 4) ? 0.80 : 0.75
		price[i] = price[1] * i * discount
	}
	split("abcde", colors, "")
	#############################################
	# tmp variables/etc - clear after each use  #
	#############################################
	_naive_combos["abcde"] = price[5]
	_naive_combos["abcd"] = price[4]
	_naive_combos["abce"] = price[4]
	_naive_combos["abde"] = price[4]
	_naive_combos["acde"] = price[4]
	_naive_combos["bcde"] = price[4]
	_naive_combos["abc"] = price[3]
	_naive_combos["abd"] = price[3]
	_naive_combos["abe"] = price[3]
	_naive_combos["acd"] = price[3]
	_naive_combos["ace"] = price[3]
	_naive_combos["ade"] = price[3]
	_naive_combos["bcd"] = price[3]
	_naive_combos["bce"] = price[3]
	_naive_combos["bde"] = price[3]
	_naive_combos["cde"] = price[3]
	_naive_combos["ab"] = price[2]
	_naive_combos["ac"] = price[2]
	_naive_combos["ad"] = price[2]
	_naive_combos["ae"] = price[2]
	_naive_combos["bc"] = price[2]
	_naive_combos["bd"] = price[2]
	_naive_combos["be"] = price[2]
	_naive_combos["cd"] = price[2]
	_naive_combos["ce"] = price[2]
	_naive_combos["de"] = price[2]
	_naive_combos["a"] = price[1]
	_naive_combos["b"] = price[1]
	_naive_combos["c"] = price[1]
	_naive_combos["d"] = price[1]
	_naive_combos["e"] = price[1]
	split("", combos, FS)
	specify_results(combos, _naive_combos)
	###
	for (idx in colors) {
		books[colors[idx]] = 0
	}
}

{
	books[colors[$1]]++
}

END {
	split("", results, FS)
	split("", cached_keys, FS)
	generate_results(results, "", books["a"], books["b"], books["c"], books["d"], books["e"])
	cheapest = NR * price[1]
	for (key in results) {
		setprice = 0
		split(key, tmp, SUBSEP)
		for (idx in tmp) {
			setprice += _naive_combos[tmp[idx]]
		}
		# printf "Subset: %s, price: %d\n", key, setprice
		cheapest = (setprice < cheapest) ? setprice : cheapest
	}
	print cheapest
}


function generate_results(results, key, a, b, c, d, e, _combo, _key)
{
	for (_combo in combos[a > 0, b > 0, c > 0, d > 0, e > 0]) {
		_key = normalize_key((key) ? key SUBSEP _combo : _combo)
		delete results[key]
		results[_key]++
		generate_results(results,
				 _key,
				 (index(_combo, "a")) ? a - 1 : a,
				 (index(_combo, "b")) ? b - 1 : b,
				 (index(_combo, "c")) ? c - 1 : c,
				 (index(_combo, "d")) ? d - 1 : d,
				 (index(_combo, "e")) ? e - 1 : e)
	}
}

function is_valid(test_str, a, b, c, d, e, _i, _val)
{
	_val = 1
	for (_i = 1; _i <= length(test_str); _i++) {
		switch (substr(test_str, _i, 1)) {
		case "a":
			if (a == 0) {
				_val = 0
			}
			break
		case "b":
			if (b == 0) {
				_val = 0
			}
			break
		case "c":
			if (c == 0) {
				_val = 0
			}
			break
		case "d":
			if (d == 0) {
				_val = 0
			}
			break
		case "e":
			if (e == 0) {
				_val = 0
			}
			break
		}
	}
	return _val
}

function normalize_key(inputstr, _i, _result)
{
	if (inputstr in cached_keys) {
		return cached_keys[inputstr]
	}
	split(inputstr, _tmp, SUBSEP)
	asort(_tmp)
	_result = _tmp[1]
	for (_i = 2; _i <= length(_tmp); _i++) {
		_result = _result SUBSEP _tmp[_i]
	}
	cached_keys[inputstr] = _result
	return _result
}

function specify_results(results, naive_input, _a, _b, _c, _d, _e, _key)
{
	for (_key in naive_input) {
		for (_a = 0; _a <= 1; _a++) {
			for (_b = 0; _b <= 1; _b++) {
				for (_c = 0; _c <= 1; _c++) {
					for (_d = 0; _d <= 1; _d++) {
						for (_e = 0; _e <= 1; _e++) {
							if (is_valid(_key, _a, _b, _c, _d, _e)) {
								results[_a, _b, _c, _d, _e][_key] = naive_input[_key]
							}
						}
					}
				}
			}
		}
	}
}
