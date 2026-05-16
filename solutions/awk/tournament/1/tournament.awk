BEGIN {
	FS = ";"
	headline = "Team                           | MP |  W |  D |  L |  P"
	split("", teams, FS)
}

/[[:alnum:]]/ {
	for (i = 1; i <= 2; i++) {
		if (! ($i in teams)) {
			teams[$i]["MP"] = 0
			teams[$i]["W"] = 0
			teams[$i]["D"] = 0
			teams[$i]["L"] = 0
			teams[$i]["P"] = 0
		}
	}
	teams[$1]["MP"]++
	teams[$2]["MP"]++
	switch ($3) {
	case "win":
		teams[$1]["W"]++
		teams[$1]["P"] += 3
		teams[$2]["L"]++
		break
	case "loss":
		teams[$2]["W"]++
		teams[$2]["P"] += 3
		teams[$1]["L"]++
		break
	case "draw":
		teams[$1]["D"]++
		teams[$1]["P"]++
		teams[$2]["D"]++
		teams[$2]["P"]++
		break
	}
}

END {
	print headline
	PROCINFO["sorted_in"] = "sort_by_points"
	for (team_name in teams) {
		printf "%-31s|%3s |%3s |%3s |%3s |%3s\n", team_name, teams[team_name]["MP"], teams[team_name]["W"], teams[team_name]["D"], teams[team_name]["L"], teams[team_name]["P"]
	}
}


function sort_by_points(idx1, val1, idx2, val2)
{
	if (val1["P"] < val2["P"]) {
		return 1
	}
	if (val1["P"] > val2["P"]) {
		return -1
	}
	return (idx1 > idx2)
}
