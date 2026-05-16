BEGIN {
	split("black brown red orange yellow green blue violet grey white", colors, FS)
	for (i = 1; i <= length(colors); i++) {
		bands[colors[i]] = i - 1
	}
}

{
	resistance = 10 * bands[$1] + bands[$2]
	if (resistance == 0) {
		print "invalid color" > "/dev/stderr"
		exit 1
	}
	print resistance
}

