BEGIN {
	price[1] = 800
	for (i = 2; i <= 5; i++) {
		discount = (i == 2) ? 0.95 : (i == 3) ? 0.9 : (i == 4) ? 0.85 : 0.75
		price[i] = price[1] * i * discount
	}
}

{
	books[$1]++
}

END {
	split("", complete_choice_array, FS)
	number_books = length(books)
	for (j = 1; j <= number_books; j++) {
		split("", choices, FS)
		choose(number_books, j)
		for (choice in choices) {
			complete_choice_array[choice]++
		}
	}
	for (k = 1; k <= 100; k++) {
		if (k % 10 == 0) {
			print "k:", k
		}
		for (complex_key in complete_choice_array) {
			# print complex_key
			#########################################
			# make copy of books - for manipulation #
			#########################################
			split("", books_copy, FS)
			for (book_no in books) {
				books_copy[book_no] = books[book_no]
			}
			################################
			# clear books out of book sets #
			################################
			bail = 0
			split(complex_key, tmp, FS)
			for (idx1 in tmp) {
				choice_group = tmp[idx1]
				print "choice group:", choice_group
				split(choice_group, _tmp, SUBSEP)
				for (idx2 in _tmp) {
					book_no = _tmp[idx2]
					printf "book_no %s, book_no in books_copy: %s\n", book_no, (book_no in books_copy)
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
			delete complete_choice_array[complex_key]
			if (bail) {
				print "skipping"
				continue
			}
			###########################################
			# if there are no books left, we are done #
			###########################################
			print complex_key
			for (book_no in books_copy) {
				print "book_copy:", book_no, books_copy[book_no]
			}
			if (length(books_copy) == 0) {
				break
			}
			##################
			# build up array #
			##################
			print "Adding new keys"
			for (l = 1; l <= length(books_copy); l++) {
				split("", choices, FS)
				choose(length(books_copy), l)
				for (choice in choices) {
					complete_choice_array[complex_key FS choice]++
				}
			}
		}
	}
	for (k in complete_choice_array) {
		printf "choice %s, array value: %s\n", k, complete_choice_array[k]
	}
}


function build_soln()
{
	if (length(soln_array) == 0) {
		for (i = 1; i <= length(books); i++) {
			split("", choices, FS)
			choose(length(books), i)
			for (key in choices) {
				for (book_no in books) {
					book_copy[book_no] = books[book_no]
				}
				split(key, tmp, SUBSEP)
				for (idx in tmp) {
					book_no = tmp[idx]
					if (book_no in book_copy) {
						book_copy[book_no]--
						if (book_copy[book_no] == 0) {
							delete book_copy[book_no]
						}
						soln_arkray[key] = book_copy
					} else {
						break
					}
				}
			}
		}
		build_soln()
	}
	recurse = 0
	for (group in soln_array) {
		leftover_books = soln_array[group]
		delete soln_array[group]
		for (i = 1; i <= length(leftover_books); i++) {
			split("", choices, FS)
			choose(length(leftover_books), i)
			for (key in choices) {
				for (book_no in leftover_books) {
					book_copy[book_no] = leftover_books[book_no]
				}
				split(key, tmp, SUBSEP)
				for (idx in tmp) {
					book_no = tmp[idx]
					if (book_no in book_copy) {
						book_copy[book_no]--
						if (book_copy[book_no] == 0) {
							delete book_copy[book_no]
						}
						soln_array[group FS key] = book_copy
						recurse = 1
					} else {
						break
					}
				}
			}
		}
	}
	if (recurse == 1) {
		print ++calls
		build_soln()
	}
}

function choose(n, r)
{
	# COMPUTE CHOICES (WITH REPETITION) HERE
	if (length(choices) == 0) {
		for (i = 1; i <= n; i++) {
			choices[i] = r - 1
		}
	}
	recurse = 0
	for (chosen in choices) {
		choices_remaining = choices[chosen]
		if (choices_remaining > 0) {
			recurse = 1
		}
		for (i = 1; i <= n; i++) {
			choices[chosen, i] = choices_remaining - 1
			delete choices[chosen]
		}
	}
	if (recurse == 1) {
		return choose(n, r)
	} else {
		# DO DEDUPLICATION HERE
		for (complex_key in choices) {
			split(complex_key, _tmp, SUBSEP)
			split("", __tmp, FS)
			asort(_tmp)
			# Deduplicating by setting of key of another a-array
			for (idx in _tmp) {
				__tmp[_tmp[idx]]++
			}
			newkey = 0
			keylength = 0
			for (idx in __tmp) {
				keylength++
				newkey = (newkey == 0) ? idx : newkey SUBSEP idx
			}
			value = choices[complex_key]
			delete choices[complex_key]
			if (keylength == r) {
				choices[newkey] = value
			}
		}
	}
}

function determine_all_possibilities(number_books)
{
	if (length(grouping_possibilities) == 0) {
		limit = (number_books < 5) ? number_books : 5
		for (i = 1; i <= limit; i++) {
			grouping_possibilities[i] = number_books - i
		}
		return determine_all_possibilities(1)
	}
	recurse = 0
	for (key in grouping_possibilities) {
		value = grouping_possibilities[key]
		if (value > 0) {
			limit = (value < 5) ? value : 5
			for (i = 1; i <= limit; i++) {
				grouping_possibilities[key, i] = value - i
				# gawk only - otherwise delete elsewhere
				delete grouping_possibilities[key]
			}
			recurse = 1
		}
	}
	if (recurse) {
		return determine_all_possibilities(1)
	}
}
