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
	# Determine all possibilities based on number of books NR = number of books
	split("", grouping_possibilities, FS)	# Needed for function on array
	determine_all_possibilities(NR)
	split("", filtered_possibilities, FS)
	for (key in grouping_possibilities) {
		# Do this differently
		split(key, foobar, SUBSEP)
		print key, grouping_possibilities[key], length(foobar)
	}
	for (book_no in books) {
		print book_no, books[book_no]
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

function filter_possibilities(){
    for (key in grouping_possibilities){
	

	
    }
}


function possibility_key_to_values(possibility_key)
{
	split(possibility_key, as_array, SUBSEP)
	for (key in as_array) {
		tmp_array[key]
	}
}

function validity_and_price(key)
{
	split(key, grouping, SUBSEP)
	grouping_dynamics	# okay ... how do we do this now that we have the grouping sizes
	for (book_no in books) {
		books_copy[book_no] = books[book_no]
	}
	for (idx in grouping) {
		size = grouping[idx]
		book_types = length(books_copy)
		if (size > book_types) {
			return -1
		}
	}
}
