{
	gsub("-", "", $0)
	if ($0 !~ /^[0-9]{9}[0-9|X]$/) {
		print "false"
	} else {
		split($0, a, "")
		total = 0
		for (i = 1; i <= 9; i++) {
			total += (11 - i) * (a[i] + 0)
		}
		total += a[10] == "X" ? 10 : a[10]
		print total % 11 == 0 ? "true" : "false"
	}
}
