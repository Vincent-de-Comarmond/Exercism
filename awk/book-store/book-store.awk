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
	split("", possibilities, FS)
	make_all_choices(possibilities, books)
	for (idx in possibilities) {
		print "Here:", idx, possibilities[idx]
	}
	print "Number of choices", length(choices)
	exit 0
	all_choices()
	split("", solutions, FS)
	for (key in possibilities) {
		solutions[key]++
	}
	for (key in possibilities) {
		printf "key: %s, value: %s\n", key, possibilities[key]
	}
	exit 0
	for (k = 1; k <= 1000; k++) {
		for (compounded in complete_choices) {
			#########################################
			# make copy of books - for manipulation #
			#########################################
			split("", books_copy, FS)
			for (book_no in books) {
				books_copy[book_no] = books[book_no]
			}
			#################################
			# Clear books out of book sets  #
			#################################
			bail = 0
			split(compounded, tmp, FS)
			for (idx1 in tmp) {
				choice_group = tmp[idx1]
				# print "choice group:", choice_group
				split(choice_group, _tmp, SUBSEP)
				for (idx2 in _tmp) {
					book_no = _tmp[idx2]
					# printf "book_no %s, book_no in books_copy: %s\n", book_no, (book_no in books_copy)
					if (! (book_no in books_copy)) {
						bail = 1
						break
					}
					books_copy[book_no]--
					if (books_copy[book_no] == 0) {
						delete books_copy[book_no]
					}
				}
				if (bail) {
					break
				}
			}
			delete complete_choices[compounded]
			if (bail) {
				# print "skipping"
				continue
			}
			###########################################
			# if there are no books left, we are done #
			###########################################
			# print compounded
			for (book_no in books_copy) {
				# print "book_copy:", book_no, books_copy[book_no]
			}
			if (length(books_copy) == 0) {
				break
			}
			##################
			# build up array #
			##################
			# print "Adding new keys"
			split("", color_bag, FS)
			for (book_col in books_copy) {
				color_bag[book_col] = books_copy[book_col]
			}
			for (l = 1; l <= length(books_copy); l++) {
				split("", choices, FS)
				make_choices_array(l)
				for (choice in choices) {
					complete_choices[compounded FS choice]++
				}
			}
		}
	}
	for (k in complete_choices) {
		printf "choice: %s, array value: %s\n", k, complete_choices[k]
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
