BEGIN {
	FS = ","
}

($1 == "needs_license" && $2 ~ /car|truck/) {
	print "true"
}

($1 == "resell_price") {
	if ($3 < 3) {
		print $2 * 0.8
	} else if ($3 <= 10) {
		print $2 * 0.7
	} else {
		print $2 * 0.5
	}
}
