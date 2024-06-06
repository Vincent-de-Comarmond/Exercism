! /^What is -?[0-9]+/ {
	if ($0 ~ /^What is/) {
		raise_error("syntax error")
	} else {
		raise_error("unknown operation")
	}
}

/^What is -?[0-9]+/ {
	gsub(/^What is /, "", $0)
	gsub(/plus/, "+", $0)
	gsub(/minus/, "-", $0)
	gsub(/multiplied by/, "*", $0)
	gsub(/divided by/, "/", $0)
	gsub(/\?/, "", $0)
	###################
	# Compute results #
	###################
	for (i = 1; i <= NF; i++) {
		if (i % 2 == 1) {
			if ($i ~ /^-?[0-9]+/) {
				switch (operator) {
				case "":
					tmp = $i
					break
				case "+":
					tmp += $i
					break
				case "-":
					tmp -= $i
					break
				case "*":
					tmp *= $i
					break
				case "/":
					tmp /= $i
				}
				operator = ""
			} else {
				raise_error("syntax error")
			}
		} else if ($i ~ /(+|-|*|\/)/) {
			operator = $i
		} else if ($i ~ /cubed/) {
			raise_error("unknown operation")
		} else {
			raise_error("syntax error")
		}
	}
	if (operator != "") {
		raise_error("syntax error")
	}
	print tmp
}


function raise_error(message)
{
	print(message) >> "/dev/stderr"
	exit 1
}
