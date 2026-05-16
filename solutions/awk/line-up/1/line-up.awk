{
	suffix = "th"
	if ($2 !~ /.*1.$/) {
		if ($2 ~ /.*1$/) {
			suffix = "st"
		} else if ($2 ~ /.*2$/) {
			suffix = "nd"
		} else if ($2 ~ /.*3$/) {
			suffix = "rd"
		}
	}
	printf "%s, you are the %s%s customer we serve today. Thank you!\n", $1, $2, suffix
}
