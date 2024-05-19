BEGIN {
	text = ""
}

{
	gsub(/(^[ \t]+|[ \t]+$)/, "", $0)
	gsub(/\t|\n|\r/, "", $0)
	text = text $0
}

END {
	if (length(text) == 0) {
		print "Fine. Be that way!"
	} else if (toupper(text) == text && text ~ /[A-z]/) {
		if (text ~ /.*\?/) {
			print "Calm down, I know what I'm doing!"
		} else {
			print "Whoa, chill out!"
		}
	} else if (text ~ /.*\?$/) {
		print "Sure."
	} else {
		print "Whatever."
	}
}

