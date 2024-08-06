#!/usr/bin/env bash
generate_palindromes() {
	local -i i idx min max digits
	local alphabet=abcdefghijklmnopqrstuvwxyz start middle="" end tmp tmp2
	local -a palindromes
	((min = $1 * $1, max = $2 * $2))
	((digits = ${#max}))
	echo "min: $min"
	echo "max: $max"
	echo "digits: $digits"
	start="${alphabet:0:$((digits / 2))}"
	read -r end < <(rev <<<"$start")
	if ((digits % 2 == 1)); then middle="${alphabet:$((digits / 2)):1}"; fi

	palindromes+=("$start$middle$end")
	while [[ "${palindromes[*]}" =~ [a-z] ]]; do
		for idx in "${!palindromes[@]}"; do
			tmp="${palindromes[$idx]}"
			tmp2="${tmp//[0-9]/}"
			if [ "${tmp2:0:1}" == "" ]; then break; fi
			for i in {0..9}; do palindromes+=("${tmp//${tmp2:0:1}/$i}"); done
			unset "palindromes[$idx]"
		done
	done

	# No palindromes that are legitimately bounded by 0s
	# for idx in "${!palindromes[@]}"; do
	# 	if [[ "${palindromes[$idx]}" =~ ^0+(.*)0+$ ]]; then
	# 		unset "palindromes[$idx]"
	# 		if [ "${BASH_REMATCH[1]}" != "" ]; then palindromes+=("${BASH_REMATCH[1]}"); fi
	# 	fi
	# done

	for tmp in "${palindromes[@]}"; do ((min <= tmp && tmp <= max)) && echo "$tmp"; done | sort -n
}

main() {
	local -i gotcha=0 i j palindrome smaller larger
	local factor_string
	local -a palindromes
	local -A factors
	# generate_palindromes "$2" "$3"
	if [ "$1" == smallest ]; then
		readarray -t palindromes < <(generate_palindromes "$2" "$3")
	else
		readarray -t palindromes < <(generate_palindromes "$2" "$3" | rev)
	fi

	for palindrome in "${palindromes[@]}"; do
		factors=()
		for ((i = $2; i <= $3; i++)); do
			((j = palindrome / i))
			if ((palindrome % i == 0 && $2 <= j && j <= $3)); then
				((smaller = i <= j ? i : j, larger = i > j ? i : j))
				gotcha=1
				if [[ "$factor_string" != *"[$smaller, $larger]"* ]]; then factor_string="$factor_string [$smaller, $larger]"; fi
			fi
		done
		if ((gotcha == 1)); then break; fi
	done

	echo "${palindrome# }:$factor_string"
}

main "$@"
