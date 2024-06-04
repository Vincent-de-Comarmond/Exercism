# These variables are initialized on the command line (using '-v'):
# - ibase
# - obase
{
	if (ibase < 2 || obase < 2) {
		print("impossible base") > "/dev/stderr"
		exit 1
	}
	for (i = 1; i <= NF; i++) {
		if ($i < 0 || $i >= ibase) {
			print("impossible digit") > "/dev/stderr"
			exit 1
		}
		power = ibase ^ (NF - i)
		base10_rep += $i * power
	}
	# I disagree with 0 being translated to "" ... but we keep this for now to pass the tests
	if (base10_rep == 0 && NF > 0) {
		print "0"
	}
	while (base10_rep > 0) {
		result = (result == "") ? base10_rep % obase : sprintf("%s %s", base10_rep % obase, result)
		base10_rep = int(base10_rep / obase)
	}
	print result
}

