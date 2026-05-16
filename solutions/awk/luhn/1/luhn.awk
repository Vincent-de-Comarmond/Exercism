{
	gsub(" ", "", $0)
	if (length($0) <= 1) {
		print "false"
		exit 0
	}
	if ($0 ~ /^[0-9]+$/) {
		total = 0
		offset = length($0) % 2
		for (i = 1; i <= length($0); i++) {
			if ((i + 1) % 2 == offset) {
				contrib = 2 * substr($0, i, 1)
				total += (contrib < 9) ? contrib : contrib - 9
			} else {
				total += substr($0, i, 1)
			}
		}
		print (total % 10 == 0) ? "true" : "false"
	} else {
		print "false"
	}
}

