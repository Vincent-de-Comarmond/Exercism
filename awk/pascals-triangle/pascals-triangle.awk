{
	split("", current, FS)
	split("", previous, FS)
	if ($1 < 2) {
		print ($1 == 0) ? "" : "1"
		exit 0
	}
	previous[1] = 1
	current[1] = 1
	print current[1]
	while (1) {
		for (i = 1; i <= length(previous); i++) {
			current[i + 1] = (i + 1 in previous) ? previous[i] + previous[i + 1] : previous[i]
		}
		for (i = 1; i <= length(current); i++) {
			printf (i == 1) ? current[i] : (i == length(current)) ? " " current[i] "\n" : " " current[i]
		}
		if (length(current) >= $1) {
			break
		}
		for (i in current) {
			previous[i] = current[i]
		}
	}
}

