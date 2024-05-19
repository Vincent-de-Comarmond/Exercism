# These variables are initialized on the command line (using '-v'):
# - type
/[0-9]+(\.[0-9+])? [0-9]+(\.[0-9+])? [0-9]+(\.[0-9+])?/ {
	if (($1 + $2 > $3) && ($1 + $3 > $2) && ($2 + $3 > $1)) {
		switch (type) {
		case "equilateral":
			print ($1 == $2 && $2 == $3) ? "true" : "false"
			break
		case "isosceles":
			print ($1 == $2 || $1 == $3 || $2 == $3) ? "true" : "false"
			break
		case "scalene":
			print ($1 != $2 && $1 != $3 && $2 != $3) ? "true" : "false"
			break
		default:
			exit 1
		}
	} else {
		print "false"
	}
}

