#!/usr/bin/env bash
main() {
	local arg value
	local -A colours=(
		["black"]=0
		["brown"]=1
		["red"]=2
		["orange"]=3
		["yellow"]=4
		["green"]=5
		["blue"]=6
		["violet"]=7
		["grey"]=8
		["white"]=9
	)
	for arg in "$@"; do
		if [ ! "${colours[$arg]+x}" ]; then
			echo "Invalid color inputted" >/dev/stderr && exit 1
		fi
	done

	value="${colours[$1]}${colours[$2]}"
	value="${value#0}"
	((value = value * (10 ** colours[$3])))
	if [ "$value" -gt 0 ]; then
		((value % (10 ** 9) == 0)) && echo $((value / (10 ** 9))) "gigaohms" && return
		((value % (10 ** 6) == 0)) && echo $((value / (10 ** 6))) "megaohms" && return
		((value % (10 ** 3) == 0)) && echo $((value / (10 ** 3))) "kiloohms" && return
	fi
	echo "$value ohms"
}
main "$@"
