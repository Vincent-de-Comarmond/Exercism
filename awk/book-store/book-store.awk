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
}

{
	books[colors[$1]]++
}

END {
	split("", book_set_combos, FS)
	split("", _all_possible_sets, FS)
	split("", _tmp, FS)
	split("", _tmp2, FS)
	split("", _basket_copy, FS)
	split("", _add_set, FS)
	analyse_book_basket(book_set_combos, books, _all_possible_sets, _tmp, _tmp2, _basket_copy, _add_set)
	for (book_combo in book_set_combos) {
		print "Here:", book_combo, book_set_combos[book_combo]
	}
	print "Number of results", length(book_set_combos)
	exit 0
}


function analyse_book_basket(results, book_basket, _all_possible_sets, _tmp, _tmp2, _basket_copy, _add_set, _recurse, _book_set, _i, _skip, _all_zero, _normalized)
{
	split("", results, FS)
	split("", _all_possible_sets, FS)
	split("", _tmp, FS)
	split("", _tmp2, FS)
	split("", _basket_copy, FS)
	split("", _add_set, FS)
	make_all_choices(_all_possible_sets, book_basket, _tmp, _tmp2)
	_recurse = 1
	while (_recurse) {
		_recurse = 0
		for (_book_set in _all_possible_sets) {
			######################
			# Make copy of books #
			######################
			split("", _basket_copy, FS)
			copy_array(book_basket, _basket_copy)
			#################################
			# Clear out chosen set of books #
			#################################
			split(_book_set, _tmp, "")
			for (_i in _tmp) {
				if (_tmp[_i] == SUBSEP) {
					continue
				}
				_basket_copy[_tmp[_i]]--
			}
			delete _all_possible_sets[_book_set]
			##############
			# Next steps #
			##############
			_skip = 0
			_all_zero = 1
			for (_i in _basket_copy) {
				if (_basket_copy[_i] < 0) {
					_skip = 1
					break
				}
				if (_basket_copy[_i] > 0) {
					_all_zero = 0
				}
			}
			if (_skip) {
				continue
			}
			if (_all_zero) {
				split("", _tmp, FS)
				_normalized = normalize_choice_set(_book_set, _tmp)
				results[_normalized]++
			} else {
				_recurse = 1
				split("", _add_set, FS)
				split("", _tmp, FS)
				split("", _tmp2, FS)
				make_all_choices(_add_set, _basket_copy, _tmp, _tmp2)
				for (_i in _add_set) {
					_all_possible_sets[_book_set SUBSEP _i]++
				}
			}
		}
	}
}

function copy_array(source, result, _i)
{
	for (_i in source) {
		result[_i] = source[_i]
	}
}

function deduplicate_sort_str(input_str, tmp, _i, _c)
{
	split(input_str, tmp, "")
	asort(tmp)
	_c = ""
	for (_i = 1; _i <= length(tmp); _i++) {
		_c = (tmp[_i] == substr(_c, length(_c), 1)) ? _c : _c tmp[_i]
	}
	split("", tmp, FS)
	return _c
}

function make_all_choices(result, color_bag, tmp, tmp2, _i, _j)
{
	for (_i = 1; _i <= length(color_bag); _i++) {
		split("", tmp, FS)
		make_choices_array(tmp, color_bag, _i, tmp2)
		for (_j in tmp) {
			result[_j]++
		}
	}
	split("", tmp, FS)
}

function make_choices_array(result, color_bag, r, tmp, _color, _choice, _recurse)
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
		return make_choices_array(result, color_bag, r, tmp)
	}
	#########################
	# DO DEDUPLICATION HERE #
	#########################
	for (_choice in result) {
		_value = result[_choice]
		delete result[_choice]
		_color = deduplicate_sort_str(_choice, tmp)
		if (length(_color) == r) {
			result[_color] = _value
		}
	}
}

function normalize_choice_set(choice_set, tmp, _normalized_choice_set, _i)
{
	split(choice_set, tmp, SUBSEP)
	asort(tmp)
	for (_i = 1; _i <= length(tmp); _i++) {
		_normalized_choice_set = (_i == 1) ? tmp[_i] : _normalized_choice_set SUBSEP tmp[_i]
	}
	return _normalized_choice_set
}
