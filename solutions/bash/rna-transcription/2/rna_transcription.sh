#!/usr/bin/env bash
main() {
	local -A translation=(["G"]="C" ["C"]="G" ["T"]="A" ["A"]="U")
	local complement="" keys="[${!translation[*]}]"
	keys="${keys// /}"
	while read -r -n1 char; do
		case "$char" in
		"") ;;
		$keys) complement="$complement${translation[$char]}" ;; # shellcheck disable=SC2254
		*) echo "Invalid nucleotide detected." >/dev/stderr && exit 1 ;;
		esac
	done <<<"$*"
	echo "$complement"
}
main "$*"
