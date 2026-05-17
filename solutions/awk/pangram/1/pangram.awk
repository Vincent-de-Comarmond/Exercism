BEGIN {
	split("abcdefghijklmnopqrstuvwxyz", tmp, "")
	for (i in tmp) {
		letters[tmp[i]]
	}
}

{
	split(tolower($0), input_lower, "")
	for (i = 1; i <= length($0); i++) {
		if (input_lower[i] in letters) {
			letters_present[input_lower[i]] += 1
		}
	}
	for (letter in letters_present) {
		count += 1
	}
	response = (count == 26) ? "true" : "false"
	print response
}

