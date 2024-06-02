BEGIN {
	price[1] = 800
	for (i = 2; i <= 5; i++) {
		discount = (i == 2) ? 0.95 : (i == 3) ? 0.9 : (i == 4) ? 0.85 : 0.75
		price[i] = price[1] * i * discount
	}
	split("abcde", colors, "")
	#############################################
	# tmp variables/etc - clear after each use  #
	#############################################
	split("", _tmp, FS)
	split("", _tmp2, FS)
}

{
	books[colors[$1]]++
}

END {
	split("", results, FS)
	split("", all_sets, FS)
	make_all_choices(all_sets, books)
	calls = 0
	recurse = 1
	while (recurse) {
		calls++
		recurse = 0
		for (chosen_set in all_sets) {
			######################
			# Make copy of books #
			######################
			split("", books_copy, FS)
			copy_array(books, books_copy)
			#################################
			# Clear out chosen set of books #
			#################################
			split(chosen_set, _tmp, "")
			for (_i in _tmp) {
				if (_tmp[_i] == SUBSEP) {
					continue
				}
				books_copy[_tmp[_i]]--
			}
			delete all_sets[chosen_set]
			##############
			# Next steps #
			##############
			skip = 0
			all_zero = 1
			for (_i in books_copy) {
				book_no = books_copy[_i]
				if (books_copy[_i] < 0) {
					skip = 1
					all_zero = 0
					break
				}
				if (books_copy[_i] > 0) {
					all_zero = 0
				}
			}
			if (skip) {
				continue
			}
			if (all_zero) {
				normalized = normalize_choice_set(chosen_set)
				results[normalized]++
			} else {
				recurse = 1
				split("", add_results, FS)
				make_all_choices(add_results, books_copy)
				for (_i in add_results) {
					all_sets[chosen_set SUBSEP _i]++
				}
			}
		}
	}
	for (choice_set in results) {
		print "Here:", choice_set, results[choice_set]
	}
	print "Number of results", length(results)
	print "calls:", calls
	exit 0
}


function copy_array(source, result, _i)
{
	for (_i in source) {
		result[_i] = source[_i]
	}
}

function deduplicate_sort_str(input_str, _i, _c)
{
	split(input_str, _tmp, "")
	asort(_tmp)
	_c = ""
	for (_i = 1; _i <= length(_tmp); _i++) {
		_c = (_tmp[_i] == substr(_c, length(_c), 1)) ? _c : _c _tmp[_i]
	}
	split("", _tmp, FS)
	return _c
}

function make_all_choices(result, color_bag, _i, _j)
{
	for (_i = 1; _i <= length(color_bag); _i++) {
		split("", _tmp2, FS)
		make_choices_array(_tmp2, color_bag, _i)
		for (_j in _tmp2) {
			result[_j]++
		}
	}
	split("", _tmp2, FS)
}

function make_choices_array(result, color_bag, r, _color, _choice, _recurse)
{
	if (length(result) == 0) {
		for (_color in color_bag) {
			result[_color] = r - 1
		}
	}
	_recurse = 0
	for (_choice in result) {
		_value = result[_choice]
		if (_value == 0) {
			continue
		}
		delete result[_choice]
		_recurse = 1
		for (_color in color_bag) {
			result[_choice _color] = _value - 1
		}
	}
	if (_recurse == 1) {
		return make_choices_array(result, color_bag, r)
	}
	#########################
	# DO DEDUPLICATION HERE #
	#########################
	for (_choice in result) {
		_value = result[_choice]
		delete result[_choice]
		_color = deduplicate_sort_str(_choice, _recurse)
		if (length(_color) == r) {
			result[_color] = _value
		}
	}
}

function normalize_choice_set(choice_set, _normalized_choice_set, _i)
{
	split(choice_set, _tmp, SUBSEP)
	asort(_tmp, _tmp2)
	for (_i = 1; _i <= length(_tmp2); _i++) {
		_normalized_choice_set = (_i == 1) ? _tmp2[_i] : _normalized_choice_set SUBSEP _tmp2[_i]
	}
	return _normalized_choice_set
}
