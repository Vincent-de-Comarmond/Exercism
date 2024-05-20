BEGIN {
	FS = ","
	actions[1] = "wink"
	actions[2] = "double blink"
	actions[4] = "close your eyes"
	actions[8] = "jump"
	actions[16] = "Reverse the order of the operations in the secret handshake."
}

{
	split("", handshake, FS)
	reverse = and($1, 16) ? 1 : 0
	for (key in actions) {
		if (key != 16) {
			if (and($1, key)) {
				handshake[length(handshake) + 1] = actions[key]
			}
		}
	}
}

END {
	previous = 0
	for (i = 1; i <= length(handshake); i++) {
		idx = (reverse) ? length(handshake) + 1 - i : i
		printf previous ? ",%s" : "%s", handshake[idx]
		previous = 1
	}
}

