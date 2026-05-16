#!/usr/bin/env bash
main() {
	local normalized coded
	local -i idx rows=0 cols=0 r=0 c=0
	read -r normalized < <(echo "$1" | tr '[:upper:]' '[:lower:]' | tr -cd '[:lower:]0-9')
	while ((rows * cols < ${#normalized})); do
		((cols++))
		if ((rows * cols >= ${#normalized})); then break; else ((rows++)); fi
	done
	printf -v normalized "%-*s" $((rows * cols)) "$normalized"
	for ((c = 0; c < cols; c++)); do
		for ((r = 0; r < rows; r++)); do
			((idx = r * cols + c))
			coded="$coded${normalized:idx:1}"
		done
		if ((c < cols - 1)); then coded="$coded "; fi
	done
	echo "$coded"
}

main "$1"
