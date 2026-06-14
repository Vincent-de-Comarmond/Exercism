BEGIN {
	split("", message, FS)
}

{
	lowered = tolower($0)
	gsub(/[^[:alnum:]]/, "", lowered)
	for (i = 1; i <= length(lowered); i++) {
		message[length(message) + 1] = substr(lowered, i, 1)
	}
}

END {
	msg_len = length(message)
	basis = int(sqrt(msg_len))
	r = basis * (basis + 1) < msg_len ? basis + 1 : basis
	c = msg_len == basis ^ 2 ? basis : basis + 1
	output = ""
	tmp = ""
	for (j = 1; j <= c; j++) {
		for (i = 0; i < r; i++) {
			tmp = (i * c + j) <= msg_len ? message[i * c + j] : " "
			output = output tmp
		}
		output = j == c ? output : output " "
	}
	print output
}

