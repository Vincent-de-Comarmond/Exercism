# These variables are initialized on the command line (using '-v'):
# - name
BEGIN {
	FS = ""
	kids["Alice"]
	kids["Bob"]
	kids["Charlie"]
	kids["David"]
	kids["Eve"]
	kids["Fred"]
	kids["Ginny"]
	kids["Harriet"]
	kids["Ileana"]
	kids["Joseph"]
	kids["Kincaid"]
	kids["Larry"]
	asorti(kids, sorted_names)
	plants["G"] = "grass"
	plants["C"] = "clover"
	plants["R"] = "radishes"
	plants["V"] = "violets"
}

{
	for (i = 1; i <= NF; i++) {
		_name = sorted_names[int((i - 1) / 2) + 1]
		kids[_name] = (length(kids[_name]) == 0) ? plants[$i] : kids[_name] " " plants[$i]
	}
}

END {
	print kids[name]
}

