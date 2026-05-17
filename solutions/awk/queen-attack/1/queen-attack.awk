{
	if ($0 ~ /^[0-7] [0-7] [0-7] [0-7]$/) {
		if ($1 == $3 && $2 == $4) {
			print("invalid") > "/dev/stderr"
			exit 1
		}
		if ($1 == $3 || $2 == $4) {
			# rows and columns
			print "true"
			next
		}
		if (($4 - $2) ^ 2 == ($3 - $1) ^ 2) {
			print "true"
			next
		}
		print "false"
		next
	} else {
		print("invalid") > "/dev/stderr"
		exit 1
	}
}

