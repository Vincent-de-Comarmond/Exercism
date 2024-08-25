#!/usr/bin/env bash

invalid() {
	local -n capacities="$1"
	local -i start="$2" other="$3"
	if ((start == 0 && other == capacities["o"])); then echo 1; else echo 0; fi
}

transfer() {
	local -i cap_s="${cap[s]}" cap_o="${cap[o]}"
	local -i diff_s="$((cap_s - $2))" diff_o="$((cap_o - $3))"

	if [[ "$1" == "s" && "$2" -eq 0 ]]; then echo "-1 -1" && return; fi
	if [[ "$1" == "o" && "$3" -eq 0 ]]; then echo "-1 -1" && return; fi

	if [ "$1" == "s" ]; then
		if ((diff_o < $2)); then echo "$(($2 - diff_o)) $cap_o" && return; fi
		echo "0 $(($3 + $2))"
	else
		if ((diff_s < $3)); then echo "$cap_s $(($3 - diff_s))" && return; fi
		echo "$(($2 + $3)) 0"
	fi
}

fill() {
	if [ "$1" == "s" ]; then
		if [ "${cap[s]}" -eq "$2" ]; then echo "-1 -1"; else echo "${cap[s]} $3"; fi
	else
		if [ "${cap[o]}" -eq "$3" ]; then echo "-1 -1"; else echo "$2 ${cap[o]}"; fi
	fi
}

empty() {
	if [ "$1" == "s" ]; then
		if [ "$2" -eq 0 ]; then echo "-1 -1"; else echo "0 $3"; fi
	else
		if [ "$3" -eq 0 ]; then echo "-1 -1"; else echo "$2 0"; fi
	fi
}

calc_gcd() {
	if (($1 == 0 || $2 == 0)); then echo "$(($1 + $2))" && return; fi
	calc_gcd "$2" "$(($1 % $2))"
}

set_copy() {
	local -i _idx _idx2 _a _b _incl=1
	local -n src1="$1" src2="$2" dst1="$3" dst2="$4"
	dst1=()
	dst2=()

	for _idx in "${!src1[@]}"; do
		_incl=1
		_a="${src1[$_idx]}"
		_b="${src2[$_idx]}"
		for _idx2 in "${!dst1[@]}"; do
			if [ "$_a $_b" == "${dst1[$_idx2]} ${dst2[$_idx2]}" ]; then
				_incl=0
				break
			fi
		done
		if [ "$_incl" -eq 0 ]; then continue; fi
		dst1+=("$_a")
		dst2+=("$_b")
	done
	src1=()
	src2=()
}

main() {
	local key func
	local -i moves=1 inval gcd idx a b c d
	local -a s=() o=(0) ss=() oo=()
	local -A cap map=(["s"]="$4")

	read -r gcd < <(calc_gcd "$1" "$2")
	if (($3 % gcd != 0)); then echo "invalid goal" >/dev/stderr && exit 1; fi
	if (($1 < $3 && $2 < $3)); then echo "invalid goal" >/dev/stderr && exit 1; fi

	if [ "$4" == "one" ]; then map["o"]="two"; else map["o"]="one"; fi
	if [ "$4" == "one" ]; then cap=(["s"]="$1" ["o"]="$2"); else cap=(["s"]="$2" ["o"]="$1"); fi

	s=("${cap[s]}")
	if [[ "${s[0]}" -eq "$3" ]]; then echo "moves: $moves, goalBucket: $4, otherBucket: 0" && return; fi

	for _ in {1..100}; do
		((moves++))
		for idx in "${!s[@]}"; do
			a="${s[$idx]}"
			b="${o[$idx]}"

			for key in "s" "o"; do
				for func in "transfer" "fill" "empty"; do
					read -r c d < <("$func" "$key" "$a" "$b")
					read -r inval < <(invalid cap "$c" "$d")
					if ((inval == 0 && (c == $3 || d == $3))); then break 4; fi
					if [[ "$c $d" != "-1 -1" && "$inval" -eq 0 ]]; then
						ss+=("$c")
						oo+=("$d")
					fi
				done
			done
		done

		set_copy ss oo s o
	done
	if [ "$c" -eq "$3" ]; then key="${map[s]}"; else key="${map[o]}"; fi
	echo "moves: $moves, goalBucket: $key, otherBucket: $((c == $3 ? d : c))"
}

main "$@"
