#!/usr/bin/env bash
main() {
	local -i val j i="${1:-0}"
	local -a current previous=(1) output=(1)

	if ((i == 0)); then return; fi
	for ((i = 1; i < $1; i++)); do
		current=(1)
		for ((j = 1; j < ${#previous[@]}; j++)); do
			((val = previous[j] + previous[j - 1]))
			current+=("$val")
		done
		current+=(1)
		previous=("${current[@]}")
		output+=("${current[*]}")
	done

	for j in "${!output[@]}"; do
		((val = ${#output[@]} - 1 - j))
		printf "%*s%s\n" "$val" "" "${output[$j]}"
	done
}

main "$1"
