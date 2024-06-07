# These variables are initialized on the command line (using '-v'):
# - key
BEGIN {
	split(tolower(key), target, "")
	num_letters = asort(target)
}

{
	split(tolower($1), candidate, "")
	cand_letters = asort(candidate)
	if (num_letters == cand_letters && tolower($1) != tolower(key)) {
		for (i = 1; i <= num_letters; i++) {
			if (candidate[i] != target[i]) {
				next	# skip to next record
			}
		}
		print $1
	}
}

