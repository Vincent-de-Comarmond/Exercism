#!/usr/bin/env bash
gen_fixed_palindromes() {
	if [ "$1" -eq 1 ]; then echo {1..9} && return; fi
	local alphabet=abcdefghijklmnopqrstuvwxyz
	local idx key val
	local start middle="" end
	local -a palindromes
	# Make template
	start="${alphabet:0:$(($1 / 2))}"
	read -r end < <(rev <<<"$start")
	if (($1 % 2 == 1)); then middle="${alphabet:$(($1 / 2)):1}"; fi
	palindromes+=("$start$middle$end")

	while [[ "${palindromes[*]}" =~ [a-z] ]]; do
		for idx in "${!palindromes[@]}"; do
			val="${palindromes[$idx]}"
			key="${val//[0-9]/}"
			if [ "${key:0:1}" == "" ]; then break; fi
			for i in {0..9}; do palindromes+=("${val//${key:0:1}/$i}"); done
			unset "palindromes[$idx]"
		done
	done

	# No palindromes that are legitimately bounded by 0s
	for idx in "${!palindromes[@]}"; do
		if [[ "${palindromes[$idx]}" =~ ^0 ]]; then unset "palindromes[$idx]"; fi
	done
	echo "${palindromes[@]}"
}

gen_palindromes() {
	local -i i j min max
	local -a tmp palindromes
	((min = $1 * $1, max = $2 * $2))
	for ((i = ${#min}; i <= ${#max}; i++)); do
		read -r -a tmp < <(gen_fixed_palindromes "$i")
		for j in "${tmp[@]}"; do
			if ((min <= j && j <= max)); then palindromes+=("$j"); fi
		done
	done
	echo "${palindromes[@]}"
}

validate() {
	if [[ "$1" != smallest && "$1" != largest ]]; then echo "first arg should be 'smallest' or 'largest'" >/dev/stderr && exit 1; fi
	if [[ "$2" > "$3" ]]; then echo "min must be <= max" >/dev/stderr && exit 1; fi
}

main() {
	local -i gotcha=0 i j small large
	local palindrome fstring
	local -a palindromes

	if [[ "$1" =~ ^s ]]; then read -r -a palindromes < <(gen_palindromes "$2" "$3"); fi
	if [[ "$1" =~ ^l ]]; then read -r -a palindromes < <(gen_palindromes "$2" "$3" | rev); fi
	for palindrome in "${palindromes[@]}"; do
		fstring=""
		for ((i = $2; i <= $3; i++)); do
			if ((palindrome % i == 0 && $2 <= palindrome / i && palindrome / i <= $3)); then
				((j = palindrome / i, gotcha = 1))
				((small = i <= palindrome / i ? i : j, large = i >= palindrome ? i : j))
				if [[ "$fstring" != *"[$small, $large]"* ]]; then fstring="$fstring [$small, $large]"; fi
			fi
		done
		if ((gotcha == 1)); then break; fi
	done
	if ((gotcha == 1)); then echo "${palindrome}:$fstring"; fi
}

validate "$@"
main "$@"
