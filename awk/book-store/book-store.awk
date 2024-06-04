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
	combos["abcde"] = price[5]
	combos["abcd"] = price[4]
	combos["abce"] = price[4]
	combos["abde"] = price[4]
	combos["acde"] = price[4]
	combos["bcde"] = price[4]
	combos["abc"] = price[3]
	combos["abd"] = price[3]
	combos["abe"] = price[3]
	combos["acd"] = price[3]
	combos["ace"] = price[3]
	combos["ade"] = price[3]
	combos["bcd"] = price[3]
	combos["bce"] = price[3]
	combos["bde"] = price[3]
	combos["cde"] = price[3]
	combos["ab"] = price[2]
	combos["ac"] = price[2]
	combos["ad"] = price[2]
	combos["ae"] = price[2]
	combos["bc"] = price[2]
	combos["bd"] = price[2]
	combos["be"] = price[2]
	combos["cd"] = price[2]
	combos["ce"] = price[2]
	combos["de"] = price[2]
	combos["a"] = price[1]
	combos["b"] = price[1]
	combos["c"] = price[1]
	combos["d"] = price[1]
	combos["e"] = price[1]
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
	split("", cached_validity, FS)
	split("", cached_keys, FS)
	
	generate_results(results, "", books["a"], books["b"], books["c"], books["d"], books["e"])
	cheapest = NR * price[1]
	for (key in results) {
		setprice = 0
		split(key, tmp, SUBSEP)
		for (idx in tmp) {
			setprice += combos[tmp[idx]]
		}
		# printf "Subset: %s, price: %d\n", key, setprice
		cheapest = (setprice < cheapest) ? setprice : cheapest
	}
	print cheapest
}


function generate_results(results, key, a, b, c, d, e, _combo, _key)
{
    for (_combo in combos) {
	if (is_valid(_combo, a > 0 , b > 0, c > 0, d > 0, e > 0)) {
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
}

function is_valid(test_str, a, b, c, d, e, _i, _val)
{
    if (test_str a b c d e in cached_validity){
	return cached_validity[test_str a b c d e]
    }
    _val = 1
    
    for (_i = 1; _i <= length(test_str); _i++) {
	switch (substr(test_str, _i, 1)) {
	case "a":
	    if (a == 0) _val = 0
	    break
	case "b":
	    if (b == 0) _val = 0
	    break
	case "c":
	    if (c == 0) _val = 0
	    break
	case "d":
	    if (d == 0) _val = 0
	    break
	case "e":
	    if (e == 0) _val = 0
	    break
	}
    }
    return _val
}

function normalize_key(inputstr, _i, _result)
{
    if (inputstr in cached_keys){
	return cached_keys[inputstr]
    }
    
    split(inputstr, _tmp, SUBSEP)
    asort(_tmp)
    _result = _tmp[1]
    for (_i = 2; _i <= length(_tmp); _i++) {
	_result = _result SUBSEP _tmp[_i]
    }
    cached_keys[inputstr]=_result
    return _result
}
