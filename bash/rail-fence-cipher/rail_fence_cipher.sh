#!/usr/bin/env bash

encode_pos() {
	local i j=0 incr=-1
	local -a buffer=()
	for ((i = 0; i < ${#2}; i++)); do
		buffer["$j"]="${buffer[$j]} $i"
		((incr = j == 0 || j == $1 - 1 ? -incr : incr))
		((j += incr))
	done
	echo "${buffer[*]}" | sed -E -e 's/\ \ / /g' -e 's/^\ //'
}

encode() {
	local -i idx
	local -a positions
	read -r -a positions < <(encode_pos "$1" "$2")
	for idx in "${positions[@]}"; do echo -n "${2:$idx:1}"; done
	echo ""
}

decode() {
	local -i idx
	local -a positions
	local -A inverted
	read -r -a positions < <(encode_pos "$1" "$2")
	for idx in "${!positions[@]}"; do inverted["${positions[$idx]}"]="$idx"; done
	for ((idx = 0; idx < ${#2}; idx++)); do echo -n "${2:${inverted[$idx]}:1}"; done
	echo ""
}

main() {
	local func
	if [[ ("$1" != "-e" && "$1" != "-d") || "$2" -le 0 ]]; then
		echo "Invalid input options" >&2 && exit 1
	fi
	if [ "$1" == "-e" ]; then func="encode"; else func="decode"; fi
	"$func" "$2" "$3"
}

main "$@"
