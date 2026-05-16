BEGIN {
	i = 1
}

{
	line[i] = $0
	i++
}

END {
	total = 0
	if (length(line[1]) != length(line[2])) {
		print "strands must be of equal length"
		exit 1
	}
	for (i = 1; i <= length(line[1]); i++) {
		total += (substr(line[1], i, 1) == substr(line[2], i, 1)) ? 0 : 1
	}
	print total
}

