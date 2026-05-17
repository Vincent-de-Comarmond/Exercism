BEGIN {
	FS = ","
}

/^[0-9]+,[0-9]$/ {
	if ($2 > length($1)) {
		print("span must be smaller than string length") > "/dev/stderr"
		exit 1
	}
	largest = 0
	for (i = 1; i <= length($1) - $2 + 1; i++) {
		subtotal = 1
		for (j = 1; j <= $2; j++) {
			subtotal *= substr($1, i + j - 1, 1)
		}
		largest = (subtotal > largest) ? subtotal : largest
	}
	print largest
	next
}

{
	if ($1 !~ /^[0-9]*$/) {
		print("input must only contain digits") > "/dev/stderr"
		exit 1
	}
	if ($2 > length($1)) {
		print("span must be smaller than string length") > "/dev/stderr"
		exit 1
	}
	if ($2 < 1) {
		print("span must not be negative") > "/dev/stderr"
		exit 1
	}
}

