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

ordered_products() {
	local -i i="$2" j="$2"

	while ((i >= $1 && j >= $1)); do
		echo $((i * j))
		if ((i > j)); then ((i--)); else ((j--)); fi
	done
}

main() {
	local -i product=1 result i
	local factor_string=""
	local -a products factors
	local -A uniq_factors
	read -r -a products < <(pallindrome_products "$2" "$3")
	if [ "$1" == smallest ]; then result="${products[0]}"; else result="${products[-1]}"; fi
	read -r -a factors < <(factor "$result" | cut -d: -f2-)
	for i in "${factors[@]}"; do
		((product *= i))
		uniq_factors["$i"]=1
	done
	uniq_factors[1]=1
	
	for i in "${!uniq_factors[@]}"; do
		factor_string="$factor_string [$i, $((product / i))]"
	done
	echo "$result:$factor_string"
}

main "$@"
