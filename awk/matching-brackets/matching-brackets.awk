{
	expect = ""
	for (i = 1; i <= length($0); i++) {
		char = substr($0, i, 1)
		# print char, expect
		expected_char = substr(expect, 1, 1)
		switch (char) {
		case "(":
			expect = ")" expect
			break
		case "[":
			expect = "]" expect
			break
		case "{":
			expect = "}" expect
			break
		case ")":
			if (expected_char == char) {
				expect = substr(expect, 2)
			} else {
				print "false"
				next
			}
			break
		case "]":
			if (expected_char == char) {
				expect = substr(expect, 2)
			} else {
				print "false"
				next
			}
			break
		case "}":
			if (expected_char == char) {
				expect = substr(expect, 2)
			} else {
				print "false"
				next
			}
			break
		default:
			break
		}
	}
	if (expect == "") {
		print "true"
		next
	} else {
		print "false"
		next
	}
}

