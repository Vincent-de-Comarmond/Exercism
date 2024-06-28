#!/usr/bin/env bash
main() {
	declare -A char_array
	while read -r -n1 char; do
		if [[ $char =~ [a-zA-Z] ]]; then
			char_array["${char^^}"]=1
		fi
	done <<<"$1"
	[[ ${#char_array[@]} -eq 26 ]] && echo "true" || echo "false"
}
main "$1"
