#!/usr/bin/env bash
main() {
	local -a data line
	local -i i j len idx nxt rect_count=0

	while IFS= read -r line; do
		for ((i = 0; i < ${#line}; i++)); do data+=("${line:i:1}"); done
		((rows++))
		((cols = ${#line}))
	done <&0

	for ((i = 0; i < rows - 1; i++)); do
		for ((j = 0; j < cols - 1; j++)); do
			((idx = i * cols + j))
			if [ "${data[$idx]}" != + ]; then continue; fi # Look for a starting "+"

			for ((len = 1; len < cols - j; len++)); do
				if [[ "${data[$idx + $len]}" == - ]]; then continue; fi
				if [[ "${data[$idx + $len]}" != + ]]; then break; fi
				# At this point we have two joined + in a row. check to see if we have joined columns
				((nxt = idx + cols))
				while ((nxt + len < ${#data[@]})); do
					if [[ "${data[$nxt]}" =~ [^\+\|] || "${data[$nxt + $len]}" =~ [^\+\|] ]]; then break; fi
					if [[ "${data[*]:$nxt:$len+1}" =~ ^\+\ (\+ |\- )*\+$ ]]; then ((rect_count++)); fi
					((nxt += cols))
				done
			done
		done
	done
	echo "$rect_count"
}

if test -t 0; then # stdin is a tty: process command line
	echo 0
else # Else stdin is not a tty: process standard input
	main
fi
