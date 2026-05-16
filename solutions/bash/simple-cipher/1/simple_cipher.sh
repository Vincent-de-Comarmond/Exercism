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

trans() {
	local key="$2" word="$3" len="${#2}" out=""
	local -i i ii a b p
	for ((i = 0; i < "${#3}"; i++)); do
		((ii = i % len))
		a="${_tr[${3:$i:1}]}"
		b="${_tr[${2:$ii:1}]}"
		if [[ "$1" =~ ^enc ]]; then ((p = (a + b) % 26)); else ((p = (a + 26 - b) % 26)); fi
		out="$out${_tr[$p]}"
	done
	echo "$out"
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
	trans "$1" "$k" "${2,,}"
}
init
main "$@"
