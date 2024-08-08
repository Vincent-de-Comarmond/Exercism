#!/usr/bin/env bash
declare -A _tr

init() {
	local -g -A _tr
	local _l idx=0
	for _l in {a..z}; do
		_tr["$_l"]="$idx"
		_tr["$idx"]="$_l"
		((idx++))
	done
}

_trans() {
	local pos
	# echo "$1"
	# echo "$2"
	# echo "$3"
	# echo "${_tr[$3]} + ${_tr[$2]} % 26"
	# echo "${_tr[$3]} - ${_tr[$2]} % 26"
	if [ "$1" == "encode" ]; then ((pos = (_tr[$3] + _tr[$2]) % 26)); else ((pos = (_tr[$3] - _tr[$2]) % 26)); fi
	((pos = pos < 0 ? pos + 26 : pos))
	echo "${_tr[$pos]}"
}

trans() {
	local i tmp output=""
	for ((i = 0; i < "${#3}"; i++)); do
		# echo "$1" "${2:i:1}" "${3:i:1}"
		read -r tmp < <(_trans "$1" "${2:i:1}" "${3:i:1}")
		output="$output$tmp"
	done
	echo "$output"
}

key() {
	local i _k length output=""
	((length = 100 + (RANDOM % 100)))
	for ((i = 0; i < length; i++)); do
		((_k = RANDOM % 26))
		output="$output${_tr[$_k]}"
	done
	echo "$output"
}

main() {
	init

	local k="$2"
	if [ "$1" == "key" ]; then key && return; fi
	if [ "$1" != "-k" ]; then read -r k < <(key); else shift 2; fi

	if [[ "$k" =~ [^[:lower:]] ]]; then echo "invalid key" >/dev/stderr && exit 1; fi
	if [[ "$1" != "encode" && "$1" != "decode" ]]; then
		echo 'Incorrect option. legitimate options are "encode", "decode" and "key".' >/dev/stderr
		exit 1
	fi
	# echo "$k"
	# echo "$2"
	trans "$1" "$k" "$2"
}
init
main "$@"
