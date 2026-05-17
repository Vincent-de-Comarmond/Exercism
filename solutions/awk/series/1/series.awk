# These variables are initialized on the command line (using '-v'):
# - len
{
	if (length($0) < 1) {
		print "series cannot be empty"
		exit 1
	}
	if (len > length($0) || len < 1) {
		print "invalid length"
		exit 1
	}
	for (i = 1; i <= length($0) - len + 1; i++) {
		tmp = substr($0, i, len)
		output = (i < length($0) - len + 1) ? tmp " " : tmp
		printf output
	}
}

