#!/usr/bin/env bash

encode() {
	local -i ord a="$1" b="$2"
	LC_CTYPE=C printf -v ord '%d' "'$3"
	((ord = (a * (ord - 97) + b) % 26)) # ascii "a" is 97
	((ord += 97))
	printf -v ord "%03o" "$ord"
	printf "\\$ord"
}

decode() {
	local -i ord a="$1" a_inv b="$2"
	LC_CTYPE=C printf -v ord '%d' "'$3"
	((ord -= (b + 97)))
	read -r a_inv < <(mmi "$a")
	((ord = (a_inv * ord) % 26 + 97))
	printf -v ord "%03o" "$ord"
	printf "\\$ord"
}

eea() { # https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
	local -i r0="$1" r1="$2" s0="${3:-1}" s1="${4:-0}" q
	if ((r0 != 0 && r1 != 0)); then
		((q = r1 / r0))
		((r2 = r1 - q * r0, s2 = s1 - q * s0))
		eea "$r2" "$r0" "$s2" "$s0"
	fi
	echo "$((r0 != 0 ? r0 : r1))" "$((r0 != 0 ? s0 : s1))"
}

mmi() {
	local -i gcd _mmi
	read -r gcd _mmi < <(eea "$1" 26)
	if ((gcd != 1)); then
		echo "A and m are not coprime. No solution" >/dev/stderr
		exit 1
	fi
	((_mmi = _mmi < 0 ? (_mmi % 26) + 26 : _mmi))
	echo "$mmi"
}

main() {
	local i input="${4,,}"
	input="${input// /}"

	for ((i = 0; i < ${#input}; i++)); do
		"$1" "$2" "$3" "${input:$i:1}"
	done
}

main "$@"
