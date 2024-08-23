#!/usr/bin/env bash
declare -a board
declare -i rows cols

count() {
	local arg arr cnt=0
	readarray -t arr <<<"$*"
	for arg in "${arr[@]}"; do if [ "$arg" == "*" ]; then ((cnt++)); fi; done
	echo "$cnt"
}

neighbours() {
	local -i c col _idx r row
	((col = $1 % cols, row = $1 / cols))

	for ((c = col - 1; c <= col + 1; c++)); do
		for ((r = row - 1; r <= row + 1; r++)); do
			if ((c == col && r == row)); then continue; fi
			if ((c < 0 || c >= cols || r < 0 || r >= rows)); then continue; fi
			((_idx = r * cols + c))
			echo "${board[$_idx]}"
		done
	done
}

print_board() {
	local -i idx
	for idx in "${!board[@]}"; do
		if (((idx + 1) % cols == 0)); then echo "${board[$idx]}"; else echo -n "${board[$idx]}"; fi
	done
}

main() {
	local arg idx cnt=0
	rows="$#"
	cols="${#1}"
	for arg in "$@"; do for ((idx = 0; idx < cols; idx++)); do board+=("${arg:$idx:1}"); done; done
	for idx in "${!board[@]}"; do
		cnt=0
		if [ "${board[$idx]}" != "*" ]; then
			read -r cnt < <(count "$(neighbours "$idx")")
			if ((cnt > 0)); then board["$idx"]="$cnt"; fi
		fi
	done
	print_board
}

main "$@"
