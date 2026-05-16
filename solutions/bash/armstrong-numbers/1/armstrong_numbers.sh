#!/usr/bin/env bash
main() {
	local digits="${#1}"
	local subtotal=0
	while read -n1 char; do
		if [[ "$char" =~ [0-9] ]]; then ((subtotal += char ** digits)); fi
	done <<<"$1"
	[[ $1 = $subtotal ]] && echo "true" || echo "false"
}
main "$@"
