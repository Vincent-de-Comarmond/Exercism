BEGIN {
	FS = ""
}

{
	tmp = ""
	for (i = 1; i <= NF; i++) {
		if ($i ~ /[0-9]/) {
			tmp = tmp $i
		}
		if ($i !~ /([0-9]|\+|\s|-|\.|\(|\))/) {
			die(($i ~ /[A-z]/) ? "letters not permitted" : "punctuations not permitted")
		}
	}
	if (length(tmp) < 10) {
		die("must not be fewer than 10 digits")
	}
	if (length(tmp) > 10) {
		if (length(tmp) == 11) {
			if (substr(tmp, 1, 1) == 1) {
				tmp = substr(tmp, 2)
			} else {
				die("11 digits must start with 1")
			}
		} else {
			die("must not be greater than 11 digits")
		}
	}
	if (substr(tmp, 1, 1) == 0) {
		die("area code cannot start with zero")
	}
	if (substr(tmp, 1, 1) == 1) {
		die("area code cannot start with one")
	}
	if (substr(tmp, 4, 1) == 0) {
		die("exchange code cannot start with zero")
	}
	if (substr(tmp, 4, 1) == 1) {
		die("exchange code cannot start with one")
	}
	print tmp
}


function die(message)
{
	print(message) >> "/dev/stderr"
	exit 1
}
