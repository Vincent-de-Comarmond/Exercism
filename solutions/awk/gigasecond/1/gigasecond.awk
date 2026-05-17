BEGIN {
	FPAT = "([0-9]+)"
}

{
	Y = $1
	m = $2
	d = $3
	h = (NF >= 4) ? $4 : 00
	M = (NF >= 5) ? $5 : 00
	s = (NF >= 6) ? $6 : 00
	time = mktime(sprintf("%s %s %s %s %s %s", Y, m, d, h, M, s), 1)
	print strftime("%Y-%m-%dT%T", time + 1000000000, 1)
}

