#!/usr/bin/env bash
bail() {
	echo "invalid arguments" >/dev/stderr
	exit 1
}

validate() {
	[[ "$#" -ne 2 && "$#" -ne 4 ]] && bail
	[[ "$1" =~ [0-9]+ && "$2" =~ [0-9]+ ]] || bail
	[ "$#" -eq 2 ] && return
	[[ "$3" =~ ^[+-]$ && "$4" =~ ^[0-9]+$ ]] || bail
}

main() {
	local hours minutes diff=0
	if [ "$#" -gt 2 ]; then
		[ "$3" == "+" ] && diff="$4" || ((diff = -$4))
	fi
	((minutes = 60 * $1 + $2 + diff))

	while ((minutes < 0)); do
		((minutes += 24 * 60))
	done
	((hours = (minutes / 60) % 24))
	((minutes = minutes % 60))
	printf "%02d:%02d\n" "$hours" "$minutes"
}

validate "$@"
main "$@"
