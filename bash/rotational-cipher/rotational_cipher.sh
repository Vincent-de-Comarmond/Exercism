#!/usr/bin/env bash
translate_letter() {
	local val translated offset shifted

	if [[ ! "$1" =~ [A-Z] ]] && [[ ! "$1" =~ [a-z] ]]; then
		printf "$1"
		return
	fi
	[[ "$1" =~ [A-Z] ]] && offset="$chr_A" || offset="$chr_a"

	printf -v val "%d" "'$1"
	((shifted = (((val - offset) + $2) % 26) + offset))
	printf -v translated "%o" "$shifted" && printf "\\$translated"
}

main() {
	local chr_A chr_a
	printf -v chr_A "%d" "'A"
	printf -v chr_a "%d" "'a"
	while IFS="" read -n1 -r char; do
		translate_letter "$char" "$2"
	done <<<"$1"
	echo ""
}

main "$@"
