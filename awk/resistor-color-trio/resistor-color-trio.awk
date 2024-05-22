BEGIN {
	color_codes["black"] = 0
	color_codes["brown"] = 1
	color_codes["red"] = 2
	color_codes["orange"] = 3
	color_codes["yellow"] = 4
	color_codes["green"] = 5
	color_codes["blue"] = 6
	color_codes["violet"] = 7
	color_codes["grey"] = 8
	color_codes["white"] = 9
}

{
	if (NF < 3) {
		print("Not a color trio") > "/dev/stderr"
		exit 1
	}
	if ($1 in color_codes && $2 in color_codes && $3 in color_codes) {
		digits = color_codes[$1] color_codes[$2]
		value = digits * 10 ^ color_codes[$3]
		if (value == 0) {
			print "0 ohms"
		} else if (value % 10 ^ 9 == 0) {
			printf "%s gigaohms", value / 10 ^ 9
		} else if (value % 10 ^ 6 == 0) {
			printf "%s megaohms", value / 10 ^ 6
		} else if (value % 10 ^ 3 == 0) {
			printf "%s kiloohms", value / 10 ^ 3
		} else {
			printf "%s ohms", value
		}
	} else {
		print("Invalid color code") > "/dev/stderr"
		exit 1
	}
}

