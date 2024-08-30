#!/usr/bin/env bash
print_arr() {
	local -n _printme="$1"
	local _key
	for _key in "${!_printme[@]}"; do echo "$_key ${_printme[$_key]}"; done
}

filter_weight() {
	local _str="" _tmp
	for _str in "${@:2}"; do
		_tmp="${_str%:*}"
		if ((_tmp <= $1)); then echo "$_str"; fi
	done
}

print_ignore() {
	local _j=0 _arg
	for _arg in "${@:2}"; do
		if ((_j != $1)); then echo "$_arg"; fi
		((_j++))
	done
}

solve() {
	# ((calls++))
	# if ((calls % 100 == 0)); then echo "calls: $calls" >&2; fi
	local -i j v w
	local -a opts tmp
	readarray -t opts < <(filter_weight "$2" "${@:3}")

	if ((cap < 0 || ${#opts[@]} < 0)); then echo "Bug: negative capacity encountered" &>/dev/stderr && exit 1; fi

	for ((j = 0; j < ${#opts[@]}; j++)); do
		v="${opts[$j]#*:}"
		w="${opts[$j]%:*}"
		((v = $1 + v, w = $2 - w))
		if ((v > best)); then best="$v"; fi
		readarray -t tmp < <(print_ignore "$j" "${opts[@]}")
		solve "$v" "$w" "${tmp[@]}"
	done
}

main() {
	if (($# < 1)); then echo "Incorrent number of arguments" && exit 1; fi

	declare -ig best=0 # calls=0
	local -i capacity="$1"
	local -a options=("${@:2}")

	solve 0 "$1" "${@:2}"
	echo "$best"
}

main "$@"
