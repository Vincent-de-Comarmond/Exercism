# These variables are initialized on the command line (using '-v'):
# - limit
{
	split("", all_magical_items, FS)
	for (i = 1; i <= NF; i++) {
		split("", magic_item_multiples, FS)
		find_multiples($i, limit, magic_item_multiples)
		for (contribution in magic_item_multiples) {
			all_magical_items[contribution] = 1
		}
	}
	total = 0
	for (contribution in all_magical_items) {
		total += contribution
	}
	print total
}


function find_multiples(base, limit, result)
{
	multiple = base
	while (multiple < limit) {
		result[multiple] = 1
		multiple += base
		if (base == 0) {
			break
		}
	}
}
