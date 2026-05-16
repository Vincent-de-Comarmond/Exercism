BEGIN {
	FPAT = "([A-Za-z]+'[A-Za-z]+|[A-Za-z]+|[0-9]+)"
}

{
	for (i = 1; i <= NF; i++) {
		words[tolower($i)] += 1
	}
}

END {
	for (word in words) {
		printf "%s: %d\n", word, words[word]
	}
}

