#!/usr/bin/env bash
main() {
	local input="${1// /}"
	[[ "$input" =~ [^0-9] ]] && echo "false" && return

	local tmp=0
	local total=0
	local even_p=$((${#input} % 2 == 0))
	[ "${#input}" -lt 2 ] && echo "false" && return
	[[ ! "$input" =~ [0-9]+ ]] && echo "false" && return
	while read -r -n1 char; do
		[ $even_p -eq 1 ] && ((tmp = 2 * char)) || tmp=$char
		((even_p = (even_p + 1) % 2))
		[[ $tmp -gt 9 ]] && ((tmp -= 9))
		((total += tmp))
	done <<<"$input"
	[[ $((total % 10 == 0)) -eq 1 ]] && echo "true" || echo "false"
}

main "$@"
