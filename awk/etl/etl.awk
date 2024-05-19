BEGIN {
	FPAT = "([0-9]+|[A-z])"
}

/[0-9]+:.*[A-z].*/ {
	for (i = 2; i <= NF; i++) {
		character_score[tolower($i)] = $1
	}
}

END {
	asorti(character_score, letters)
	for (j in letters) {
		printf "%s,%d\n", letters[j], character_score[letters[j]]
	}
}

