{
	if (length($0) > 0) {
		for (i = 1; i <= NF - 1; i++) {
			j = i + 1
			printf "For want of a %s the %s was lost.\n", $i, $j
		}
		printf "And all for the want of a %s.", $1
	}
}

