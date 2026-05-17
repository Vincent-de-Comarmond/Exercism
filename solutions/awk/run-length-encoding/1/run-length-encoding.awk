# These variables are initialized on the command line (using '-v'):
# - type
BEGIN {
	FS = ""
}

{
	if (type == "encode") {
		current = 1
		for (i = 1; i <= NF; i++) {
			current += (i > 1 && $i != $(i - 1)) ? 1 : 0
			order[current][$i]++
		}
	} else {
		for (i = 1; i <= NF; i++) {
			if ($i ~ /[0-9]/) {
				repeats = repeats $i
			} else {
				repeats = (repeats == "") ? 1 : repeats + 0
				for (j = 1; j <= repeats + 0; j++) {
					printf $i
				}
				repeats = ""
			}
		}
		print ""
	}
}

END {
	if (type == "encode") {
		for (i in order) {
			for (letter in order[i]) {
				prefix = (order[i][letter] > 1) ? order[i][letter] : ""
				printf "%s%s", prefix, letter
			}
		}
		print ""
	}
}

