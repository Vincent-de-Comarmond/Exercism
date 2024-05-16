{
	if ($0 == "total") {
		print sum_of_n(1, 2, 64)
	} else if ($0 ~ /[+-]?[[:digit:]]/) {
		if (($0 < 1) || ($0 > 64)) {
			print "square must be between 1 and 64"
			exit 1
		}
		print 2 ^ ($0 - 1)
	}
}


function sum_of_n(a, r, n)
{
	return (a * (r ^ n - 1) / (r - 1))
}
