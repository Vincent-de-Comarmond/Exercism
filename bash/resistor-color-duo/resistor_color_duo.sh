#!/usr/bin/env bash
main() {
	declare -A colours
	colours["black"]=0
	colours["brown"]=1
	colours["red"]=2
	colours["orange"]=3
	colours["yellow"]=4
	colours["green"]=5
	colours["blue"]=6
	colours["violet"]=7
	colours["grey"]=8
	colours["white"]=9
	[ -z "${colours[$1]}" ] && echo "invalid color" >/dev/stderr && exit 1
	[ -z "${colours[$2]}" ] && echo "invalid color" >/dev/stderr && exit 1
	local tmp="${colours[$1]}""${colours[$2]}"
	printf "%d\n" "${tmp#0}"
}
main "$1" "$2"
