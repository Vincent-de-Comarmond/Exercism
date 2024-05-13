BEGIN {
	empty_file = 1
}

{
	empty_file = 0
	sub(/^$/, "you", $0)
	printf "One for %s, one for me.", $0
}

END {
	if (empty_file) {
		print "One for you, one for me."
	}
}

