#!/usr/bin/env bash
die() { echo "$1" >/dev/stderr && exit 1; }

ext_euclid() { # https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
	local -i r0="$1" r1="$2" s0="${3:-1}" s1="${4:-0}" gcd mmi
	if ((r0 == 0 || r1 == 0)); then
		((gcd = r0 != 0 ? r0 : r1, mmi = r0 != 0 ? s0 : s1))
		echo "$gcd" "$((mmi = mmi < 0 ? mmi % 26 + 26 : mmi))" && return
	fi
	((r2 = r1 - (r1 / r0) * r0, s2 = s1 - (r1 / r0) * s0))
	ext_euclid "$r2" "$r0" "$s2" "$s0"
}

to_ord() {
	local -i ord
	LC_CTYPE=C printf -v ord '%d' "'$1"
	echo -n "$((ord - 97))" # The 97 offset is the reason I usually use arrays/associative-arrays for this stuff
}

to_char() {
	local -i ord="$1"
	((ord += 97))
	printf "\\$(printf "%03o" "$ord")"
}

main() {
	local -i i a="$2" b="$3" m=26 gcd mmi ord
	local input="${4,,}" output="" char=""

	read -r input < <(tr -cd "a-z0-9" <<<"$input")
	read -r gcd mmi < <(ext_euclid "$a" "$m") # For encoding this just tests if they're relatively prime
	if ((gcd != 1)); then die "a and m must be coprime."; fi

	for ((i = 0; i < ${#input}; i++)); do
		char="${input:$i:1}"
		if [[ "$char" =~ [a-z] ]]; then
			read -r ord < <(to_ord "$char")
			if [ "$1" == "encode" ]; then ((ord = (a * ord + b) % 26)); else ((ord = mmi * (ord - b) % 26)); fi
			read -r char < <(to_char "$((ord < 0 ? ord + 26 : ord))")
		fi
		if [ "$1" == encode ] && ((0 < i && i % 5 == 0)); then char=" $char"; fi
		output="$output$char"
	done
	echo "$output"
}

main "$@"
