BEGIN {
	FS = ""
}

{
	for (i = 1; i <= NF; i++) {
		if ($i ~ /[A-z]/) {
			counts[tolower($i)]++
			if (counts[tolower($i)] > 1) {
				print "false"
				exit 0
			}
		}
	}
	print "true"
}

