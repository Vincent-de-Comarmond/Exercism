# These variables are initialized on the command line (using '-v'):
# -direction
BEGIN {
	FS = ""
	_alphabet = "abcdefghijklmnopqrstuvwxyz"
	for (i = 1; i <= 26; i++) {
		mapping[toupper(substr(_alphabet, i, 1))] = substr(_alphabet, 27 - i, 1)
		mapping[substr(_alphabet, i, 1)] = substr(_alphabet, 27 - i, 1)
	}
	for (i = 0; i <= 9; i++) {
		mapping[i] = i
	}
}

{
	space = 5
	tmp = ""
	for (i = 1; i <= NF; i++) {
		if ($i ~ "[A-z0-9]") {
			space--
			tmp = (space == 0 && direction == "encode") ? tmp mapping[$i] " " : tmp mapping[$i]
			space = (space == 0) ? space = 5 : space
		}
	}
	sub(/\s$/, "", tmp)
	print tmp
}

