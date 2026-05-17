{
	if ($1 % 4 == 0) {
		if ($1 % 400 == 0) {
			print "true"
		} else if ($1 % 100 == 0) {
			print "false"
		} else {
			print "true"
		}
	} else {
		print "false"
	}
}

