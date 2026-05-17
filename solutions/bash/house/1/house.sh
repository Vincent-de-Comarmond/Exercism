#!/usr/bin/env bash
validate() {
	if [ "$#" -ne 2 ] || [ "$1" -le 0 ] || [ "$1" -gt 12 ] || [ "$1" -gt "$2" ]; then
		echo "invalid" >/dev/stderr
		exit 1
	fi
	if [ "$2" -le 0 ] || [ "$2" -gt 12 ]; then
		echo "invalid" >/dev/stderr
		exit 1
	fi
}

main() {
	local i j end=""
	local -a obs=(
		"house that Jack built"
		"malt"
		"rat"
		"cat"
		"dog"
		"cow with the crumpled horn"
		"maiden all forlorn"
		"man all tattered and torn"
		"priest all shaven and shorn"
		"rooster that crowed in the morn"
		"farmer sowing his corn"
		"horse and the hound and the horn"
	)

	local -a acts=(
		"This is"
		"lay in"
		"ate"
		"killed"
		"worried"
		"tossed"
		"milked"
		"kissed"
		"married"
		"woke"
		"kept"
		"belonged to"
	)

	for ((j = $1 - 1; j <= $2 - 1; j++)); do
		for ((i = $j; i >= 0; i--)); do
			[ "$i" -eq 0 ] && end="." || end=""
			[ "$i" -eq "$j" ] && printf "${acts[0]} the ${obs[$i]}%s\n" "$end" || :
			[ "$i" -eq 0 ] && break || :
			[ "$i" -eq 1 ] && end="." || end=""
			printf "that ${acts[$i]} the ${obs[$i - 1]}%s\n" "$end"
		done
		((j != $2 - 1)) && echo "" || :
	done
}
validate "$@"
main "$1" "$2"
