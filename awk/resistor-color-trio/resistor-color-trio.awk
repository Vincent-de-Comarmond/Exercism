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
	if (NF != 3) {
		print("Not a color trio") > "/dev/stderr"
		exit 1
	}
	value = color_codes[$1] color_codes[$2]
	multiplier = 10 ^ color_codes[$3]
	if (multiplier < 3) {
		printf "%s ohms", value * multiplier
	} else if (multiplier < 6) {
		multiplier /= 1000
		printf "%s kiloohms", value * multiplier
	} else if (multiplier < 9) {
		multiplier /= 1000000
		printf "%s megaohms", value * multiplier
	} else {
		printf "%s gigaohms", value
	}
}

