#!/usr/bin/env bash
is_pallindrome() {
	local alpha beta half
	((half = ${#1} / 2))
	alpha="${1:0:$half}"
	if ((${#1} % 2 == 0)); then beta="${1:$half}"; else beta="${1:$((half + 1))}"; fi
	read -r beta < <(rev <<<"$beta")
	if [ "$alpha" == "$beta" ]; then return 0; fi
	return 1
}

pallindrome_products() {
	local -i i j product
	local -a products
	for ((i = $1; i <= $2; i++)); do
		for ((j = i; j <= $2; j++)); do
			((product = i * j))
			if is_pallindrome "$product"; then products+=("$product"); fi
		done
	done
	echo "${products[@]}"
}
main() {
	local -i result i j
	local -a products factors
	read -r -a products < <(pallindrome_products "$2" "$3")
	if [ "$1" == smallest ]; then result="${products[0]}"; else result="${products[-1]}"; fi
	read -r -a factors < <(factor "$result" | cut -d: -f2-)
	echo "${factors[@]}"
}

main "$@"
