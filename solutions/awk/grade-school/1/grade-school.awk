# These variables are initialized on the command line (using '-v'):
# - action
# - grade
BEGIN {
	FS = ","
	split("", students, FS)
}

{
	grades[$2] = 1
	if (! ($1 in students)) {
		students[$1] = $2
	}
}

END {
	first = 1
	n_studs = asorti(students, sorted_students)
	if (action == "grade") {
		n_grades = 1
		sorted_grades[1] = grade
	} else {
		n_grades = asorti(grades, sorted_grades)
	}
	for (i = 1; i <= n_grades; i++) {
		current_grade = sorted_grades[i]
		for (j = 1; j <= n_studs; j++) {
			name = sorted_students[j]
			if (students[name] == current_grade) {
				printf (first) ? "%s" : ",%s", name
				first = 0
			}
		}
	}
}

