# These variables are initialized on the command line (using '-v'):
# - x
# - y
# - dir
BEGIN {
	movements["L"] = -1
	movements["A"] = 0
	movements["R"] = 1
	directions["north"] = 1
	directions["east"] = 1
	directions["south"] = -1
	directions["west"] = -1
	split("north east south west", dir_enc, FS)
	for (i in dir_enc) {
		inv_dir_enc[dir_enc[i]] = i
	}
	x = (x == "") ? 0 : x
	y = (y == "") ? 0 : y
	dir = (dir == "") ? "north" : dir
	errors_encountered = 0
	if (! (dir in directions)) {
		print("invalid direction") > "/dev/stderr"
		errors_encountered = 1
	}
}

{
	for (i = 1; i <= NF; i++) {
		execute_action($i)
	}
}

END {
	if (! (errors_encountered)) {
		print x, y, dir
	} else {
		exit 1
	}
}


function execute_action(action)
{
	if (! (action in movements)) {
		print("invalid instruction") > "/dev/stderr"
		errors_encountered = 1
	}
	if (movements[action] == 0) {
		switch (dir) {
		case "north":
			y++
			break
		case "east":
			x++
			break
		case "south":
			y--
			break
		case "west":
			x--
			break
		}
		pass
	} else {
		current_encoding = inv_dir_enc[dir]
		new_encoding = current_encoding + movements[action]
		if (new_encoding < 1) {
			new_encoding += 4
		} else if (new_encoding > 4) {
			new_encoding -= 4
		}
		dir = dir_enc[new_encoding]
		# print direction, xx, yy
	}
}
