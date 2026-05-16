#!/usr/bin/env bash
encode() {
	local i cnt=1 letter="${1:i:1}" encoded=""
	for ((i = 1; i < ${#1}; i++)); do
		if [ "$letter" == "${1:i:1}" ]; then ((cnt++)); else
			if [ "$cnt" -eq 1 ]; then cnt=""; fi
			encoded="$encoded$cnt$letter"
			letter="${1:i:1}"
			cnt=1
		fi
	done
	if [ "$cnt" -eq 1 ]; then cnt=""; fi
	echo "$encoded$cnt$letter"
}

decode() {
	local i number=0 decoded tmp
	for ((i = 0; i < ${#1}; i++)); do
		if [[ "${1:i:1}" =~ [0-9] ]]; then
			number="$number${1:i:1}"
		else
			if [ "$number" -ne 0 ]; then
				tmp="$(yes "${1:i:1}" | head -n "$number" | tr -d "\n")"
			else
				tmp="${1:i:1}"
			fi
			decoded="$decoded$tmp"
			number=0
		fi
	done
	echo "$decoded"
}

"$1" "$2"
