# These variables are initialized on the command line (using '-v'):
# - distance
BEGIN {
	split("abcdefghijklmnopqrstuvwxyz", lowercase, "")
	for (i = 0; i < 26; i++) {
		cipher[lowercase[i + 1]] = lowercase[(i + distance) % 26 + 1]
	}
	for (letter in lowercase) {
		key = lowercase[letter]
		cipher[toupper(key)] = toupper(cipher[key])
	}
}

END {
	for (i = 1; i <= length($0); i++) {
		char = substr($0, i, 1)
		if (char in cipher) {
			printf "%s", cipher[char]
		} else {
			printf "%s", char
		}
	}
}

