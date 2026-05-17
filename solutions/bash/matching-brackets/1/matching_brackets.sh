#!/usr/bin/env bash
main() {
	declare -a current
	declare -A complements
	complements=(["]"]="[" ["}"]="{" [")"]="(")
	local comp

	while read -r -n1 char; do
		case "$char" in
		[\]\)\}])
			comp="${complements[$char]}"
			[ "${#current[@]}" -le 0 ] && echo "false" && return
			[ "${current[-1]}" != "$comp" ] && echo "false" && return
			unset 'current[-1]'
			;;
		[\[\(\{])
			current+=("$char")
			;;
		esac
	done <<<"$*"

	[ "${#current[@]}" -eq 0 ] && echo "true" || echo "false"
}

main "$*"
