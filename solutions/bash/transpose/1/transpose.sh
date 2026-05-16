#!/usr/bin/env bash
main() {
	local -a lines transposed
	readarray -t lines
	local i line tmp maxsize=0
	for line in "${lines[@]}"; do ((maxsize = ${#line} > maxsize ? ${#line} : maxsize)); done

	for ((i = 0; i < maxsize; i++)); do
		for line in "${lines[@]}"; do
			if ((i < ${#line})); then tmp="${line:$i:1}"; else tmp=" "; fi
			transposed["$i"]="${transposed[$i]}$tmp"
		done
	done

	maxsize=0
	shopt -s extglob
	for ((i = ${#transposed[@]} - 1; i >= 0; i--)); do
		tmp="${transposed[$i]%%+([[:space:]])}"
		((maxsize = ${#tmp} > maxsize ? ${#tmp} : maxsize))
		tmp="${transposed[$i]}"
		transposed["$i"]="${tmp:0:$maxsize}"
	done

	for line in "${transposed[@]}"; do echo "$line"; done
}
main "$@"
