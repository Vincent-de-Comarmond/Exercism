{
	input = $1
	if (input > 0) {
		binary = ""
		while (input > 0) {
			binary = sprintf("%s%s", input % 2, binary)
			input = (input - input % 2) / 2
		}
	} else {
		binary = "0"
	}
	num_eggs = 0
	for (i = 1; i <= length(binary); i++) {
		num_eggs += substr(binary, i, 1)
	}
	print num_eggs
}

