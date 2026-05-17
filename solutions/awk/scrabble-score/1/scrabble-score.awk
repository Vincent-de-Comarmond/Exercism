BEGIN {
	points["A"] = 1
	points["E"] = 1
	points["I"] = 1
	points["O"] = 1
	points["U"] = 1
	points["L"] = 1
	points["N"] = 1
	points["R"] = 1
	points["S"] = 1
	points["T"] = 1
	points["D"] = 2
	points["G"] = 2
	points["B"] = 3
	points["C"] = 3
	points["M"] = 3
	points["P"] = 3
	points["F"] = 4
	points["H"] = 4
	points["V"] = 4
	points["W"] = 4
	points["Y"] = 4
	points["K"] = 5
	points["J"] = 8
	points["X"] = 8
	points["Q"] = 10
	points["Z"] = 10
	total = 0
}

{
	tmp = toupper($0)
	for (i = 1; i <= length($0); i++) {
		total += points[substr(tmp, i, 1)]
	}
}

END {
	printf "%s,%d\n", tmp, total
}

