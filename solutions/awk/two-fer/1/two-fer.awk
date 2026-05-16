BEGIN {
	empty_file = 1
}

{
	empty_file = 0
	sub(/^$/, "you", $1)
	printf "One for %s, one for me.", $1
}

END {
	if (empty_file) {
		print "One for you, one for me."
	}
}

