
@namespace "listops"	# Append to a list all the elements of another list.
# Or append to a list a single new element


function append(list, item_or_list, _i)
{
	if (! (awk::typeof(item_or_list) == "array")) {
		list[length(list) + 1] = item_or_list
	} else {
		for (_i in item_or_list) {
			list[length(list) + 1] = item_or_list[_i]
		}
	}
}

# Concatenate is flattening a list of lists one level
function concat(list, result, _i, _j)
{
	split("", result, FS)
	for (_i in list) {
		for (_j in list[_i]) {
			result[length(result) + 1] = list[_i][_j]
		}
	}
}

# Only the list elements that pass the given function.
function filter(list, funcname, result, _i)
{
	split("", result, FS)
	for (_i in list) {
		if (@awk::funcname(list[_i])) {
			result[length(result) + 1] = list[_i]
		}
	}
}

# Left-fold the list using the function and the initial value.
function foldl(list, funcname, initial, _i)
{
	for (_i = 1; _i <= length(list); _i++) {
		initial = @awk::funcname(initial, list[_i])
	}
	return initial
}

# Right-fold the list using the function and the initial value.
function foldr(list, funcname, initial)
{
	for (_i = length(list); _i >= 1; _i--) {
		initial = @awk::funcname(list[_i], initial)
	}
	return initial
}

# Transform the list elements, using the given function, into a new list.
function map(list, funcname, result, _i)
{
	split("", result, FS)
	for (_i = 1; _i <= length(list); _i++) {
		result[length(result) + 1] = @awk::funcname(list[_i])
	}
}

# the list reversed
function reverse(list, result, _i)
{
	split("", result, FS)
	for (_i = length(list); _i >= 1; _i--) {
		result[length(result) + 1] = list[_i]
	}
}
