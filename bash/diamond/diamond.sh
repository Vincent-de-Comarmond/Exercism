#!/usr/bin/env bash
main() {
	local letters=ABCDEFGHIJKLMNOPQRSTUVWXYZ t
	local -i i j l
	t="${letters%%"$1"*}" && l="${#t}"
	for ((i = 0; i <= 2 * l; i++)); do
		((j = i <= l ? i : 2 * l - i))
		t="${letters:j:1}"
		case "$j" in
		0) printf "%*s%*s\n" $((l + 1)) "$t" $((l)) "" ;;
		"$l") printf "%*s%*s\n" $((l - j + 1)) "$t" $((2 * j)) "$t" ;;
		*) printf "%*s%*s%*s\n" $((l - j + 1)) "$t" $((2 * j)) "$t" $((l - j)) "" ;;
		esac
	done
}
main "$1"
