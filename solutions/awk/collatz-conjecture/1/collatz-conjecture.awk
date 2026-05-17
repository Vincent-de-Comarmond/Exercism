/(^0$|[^0-9])/ {
	print("Error: Only positive numbers are allowed") > "/dev/stderr"
	exit 1
}

/^[0-9]+/ {
	steps = 0
	var = $1
	while (var != 1) {
		if (var % 2 == 0) {
			var = var / 2
		} else {
			var = 3 * var + 1
		}
		steps++
	}
}

END {
	print steps
}

