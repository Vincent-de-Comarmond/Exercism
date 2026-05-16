# These variables are initialized on the command line (using '-v'):
# - flags
# - pattern
BEGIN {
	split(flags, _tmp, FS)
	for (_i in _tmp) {
		switch (_tmp[_i]) {
		case "n":
			n = 1
			break
		case "l":
			l = 1
			break
		case "i":
			i = 1
			break
		case "v":
			v = 1
			break
		case "x":
			x = 1
			break
		}
	}
	if (ARGC > 2) {
		m = 1
	}
	split("", uniques, FS)
}

{
	input = (i) ? tolower($0) : $0
	pattern = (i) ? tolower(pattern) : pattern
	if (v) {
		pattern_matched = 0
		if (input ~ pattern) {
			pattern_matched = 1
		} else {
			found = 1
			if (m && n) {
				print FILENAME ":" FNR ":" $0
			} else if (n) {
				print FNR ":" $0
			} else if (m) {
				print FILENAME ":" $0
			} else {
				print $0
			}
		}
	} else if (input ~ pattern) {
		if (l) {
			found = 1
			if (! (FILENAME in uniques)) {
				print FILENAME
				uniques[FILENAME] = 1
			}
		} else if (m && n) {
			found = 1
			print FILENAME ":" FNR ":" $0
		} else if (n && x) {
			found = (found) ? found : 0
			if (input ~ ("^" pattern "$")) {
				found = 1
				tmp = ""
				tmp = (m && n) ? FILENAME ":" FNR ":" : tmp
				tmp = (m) ? FILENAME ":" : tmp
				tmp = (n) ? FNR ":" : tmp
				print tmp $0
			}
		} else if (n) {
			found = 1
			print FNR ":" $0
		} else if (x) {
			found = (found) ? found : 0
			if (input ~ ("^" pattern "$")) {
				found = 1
				print (m) ? FILENAME ":" pattern : pattern
			}
		} else if (m) {
			found = 1
			print FILENAME ":" $0
		} else {
			found = 1
			print $0
		}
	}
}

END {
	if (! (found)) {
		exit 1
	}
}

